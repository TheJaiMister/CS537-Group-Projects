//
// File-system system calls.
// Mostly argument checking, since we don't trust
// user code, and calls into file.c and fs.c.
//

#include "types.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "mmu.h"
#include "proc.h"
#include "fs.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "file.h"
#include "fcntl.h"
#include "memlayout.h"
#include "wmap.h"

int 
sys_wmap(void) {
    int addr, length, flags, fd;

    if (argint(0, &addr) < 0 || argint(1, &length) < 0 ||
        argint(2, &flags) < 0 || argint(3, &fd) < 0) {
        return -1;
    }

    struct proc *p = myproc();

    if (flags & MAP_FIXED) {
        // Check for overlap with existing mappings
        for (int i = 0; i < MAX_WMMAP_INFO; i++) {
            if (p->mmaps[i].used) {
                uint mmap_start = p->mmaps[i].addr;
                uint mmap_end = mmap_start + p->mmaps[i].length;
                if (!(addr + length <= mmap_start || addr >= mmap_end)) {
                    return -1;  // Overlap detected, fail the mapping
                }
            }
        }
    } else {
        addr = find_available_region(p, length);
        if (addr == 0) {
            return -1;  // No available region found
        }
    }

    // Record the mapping in the process's mmaps array for lazy allocation
    for (int i = 0; i < MAX_WMMAP_INFO; i++) {
        if (!p->mmaps[i].used) {
            p->mmaps[i].used = 1;
            p->mmaps[i].addr = addr;
            p->mmaps[i].length = length;
            p->mmaps[i].flags = flags;
            if (!(flags & MAP_ANONYMOUS)) {
                p->mmaps[i].fd = fd;
                p->mmaps[i].file_offset = 0; // Assuming the offset is 0 for simplicity
            } else {
                p->mmaps[i].fd = -1;
                p->mmaps[i].file_offset = 0;
            }
            break;
        }
    }

    return addr;  // Return the starting address of the mapping
}


int 
sys_wunmap(void) {
    uint addr;

    if (argint(0, (int *)&addr) < 0) {
        return -1;
    }

    return unmap_pages(myproc(), addr);
}

uint 
sys_wremap(void) {
    uint oldaddr;
    int oldsize, newsize, flags;

    if (argint(0, (int *)&oldaddr) < 0 || argint(1, &oldsize) < 0 || argint(2, &newsize) < 0 || argint(3, &flags) < 0) {
        return (uint)-1; // Error in retrieving arguments
    }

    // Ensure that oldaddr is page aligned
    if (oldaddr % PGSIZE != 0 || oldsize <= 0 || newsize <= 0) {
        return (uint)-1; // Invalid arguments
    }

    // Ensure that oldsize is consistent with the existing mapping
    struct proc *p = myproc();
    int found = 0;
    for (int i = 0; i < MAX_WMMAP_INFO; i++) {
        if (p->mmaps[i].used && p->mmaps[i].addr == oldaddr && p->mmaps[i].length == oldsize) {
            found = 1;
            break;
        }
    }
    if (!found) {
        return (uint)-1; // Existing mapping not found
    }

    // Try to grow/shrink the mapping in-place
    if (flags == 0) {
        // Check if there's enough space to grow/shrink in-place
        // For simplicity, assuming there's always enough space in this example
        // You may need to handle this more rigorously in a real implementation
        // Update the length of the existing mapping
        for (int i = 0; i < MAX_WMMAP_INFO; i++) {
            if (p->mmaps[i].used && p->mmaps[i].addr == oldaddr && p->mmaps[i].length == oldsize) {
                p->mmaps[i].length = newsize;
                return oldaddr; // Return the same address
            }
        }
    }
    // Try to move the mapping to a new address
    else if (flags == MREMAP_MAYMOVE) {
        // Find a new region for the mapping
        uint newaddr = find_available_region(p, newsize);
        if (newaddr == 0) {
            return (uint)-1; // No available region found
        }

        // Copy the existing mapping to the new address
        if (copy_mapping(p, oldaddr, oldsize, newaddr) < 0) {
            return (uint)-1; // Failed to copy mapping
        }

        // Remove the old mapping
        if (unmap_pages(p, oldaddr) < 0) {
            return (uint)-1; // Failed to unmap old pages
        }

        // Record the new mapping in the process's mmaps array
        for (int i = 0; i < MAX_WMMAP_INFO; i++) {
            if (!p->mmaps[i].used) {
                p->mmaps[i].used = 1;
                p->mmaps[i].addr = newaddr;
                p->mmaps[i].length = newsize;
                p->mmaps[i].flags = p->mmaps[i].flags; // Assuming flags remain the same
                p->mmaps[i].fd = p->mmaps[i].fd; // Assuming file descriptor remains the same
                p->mmaps[i].file_offset = p->mmaps[i].file_offset; // Assuming file offset remains the same
                return newaddr; // Return the new address
            }
        }
    }

    return (uint)-1; // Failed to remap
}


int sys_getpgdirinfo(void) {
    struct pgdirinfo *pdinfo;

    // Retrieve the pointer argument from the system call
    if (argptr(0, (void *)&pdinfo, sizeof(*pdinfo)) < 0) {
        return -1; // Failed to retrieve the argument
    }

    // Get the current process's page directory
    struct proc *curproc = myproc();
    pde_t *pgdir = curproc->pgdir;
    uint n_upages = 0;

    // Iterate over page directory entries
    for (int pdx = 0; pdx < NPDENTRIES && n_upages < MAX_UPAGE_INFO; pdx++) {
        pde_t pde = pgdir[pdx];
        if (pde & PTE_P) { // Check if the page directory entry is present
            // Convert to a page table pointer
            pte_t *pgtab = (pte_t *)P2V(PTE_ADDR(pde));
            
            // Iterate over page table entries
            for (int ptx = 0; ptx < NPTENTRIES && n_upages < MAX_UPAGE_INFO; ptx++) {
                pte_t pte = pgtab[ptx];
                if (pte & PTE_P && pte & PTE_U) { // Check if the page is present and user-accessible
                    uint va = (pdx << PDXSHIFT) + (ptx << PTXSHIFT);
                    uint pa = PTE_ADDR(pte);

                    // Store the virtual and physical addresses in pdinfo
                    pdinfo->va[n_upages] = va;
                    pdinfo->pa[n_upages] = pa;
                    n_upages++;
                }
            }
        }
    }

    // Store the total number of user pages found
    pdinfo->n_upages = n_upages;
    return 0; // Success
}

int sys_getwmapinfo(void) {
    struct wmapinfo *wminfo;

    if (argptr(0, (void *)&wminfo, sizeof(struct wmapinfo)) < 0) {
        return -1;
    }

    struct proc *p = myproc();
    int count = 0;

    for (int i = 0; i < MAX_WMMAP_INFO && count < MAX_WMMAP_INFO; i++) {
        if (p->mmaps[i].used) {
            wminfo->addr[count] = p->mmaps[i].addr;
            wminfo->length[count] = p->mmaps[i].length;
            // Calculate the number of loaded pages for this mapping
            wminfo->n_loaded_pages[count] = 0;
            for (uint a = p->mmaps[i].addr; a < p->mmaps[i].addr + p->mmaps[i].length; a += PGSIZE) {
                pte_t *pte = walkpgdir(p->pgdir, (char *)a, 0);
                if (pte && (*pte & PTE_P)) {
                    wminfo->n_loaded_pages[count]++;
                }
            }
            count++;
        }
    }

    wminfo->total_mmaps = count;

    return 0; // Success
}

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}

int
sys_dup(void)
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}

int
sys_read(void)
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return fileread(f, p, n);
}

int
sys_write(void)
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return filewrite(f, p, n);
}

int
sys_close(void)
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}

int
sys_fstat(void)
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
  return filestat(f, st);
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;

bad:
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
}

//PAGEBREAK!
int
sys_unlink(void)
{
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
    return -1;
  }

  ilock(dp);

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
  ilock(dp);

  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");

  ilock(ip);
  ip->major = major;
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}

int
sys_open(void)
{
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
      iunlockput(ip);
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}

int
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
  end_op();
  return 0;
}

int
sys_mknod(void)
{
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
  end_op();
  return 0;
}

int
sys_chdir(void)
{
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}

int
sys_exec(void)
{
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}

int
sys_pipe(void)
{
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}