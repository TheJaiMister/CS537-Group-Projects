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
sys_getwmapinfo(void) {

    struct wmapinfo *wminfo;

    if(argptr(0,(void*)&wminfo, sizeof(wminfo)) < 0){
      return FAILED;
    }

    struct proc *curproc = myproc();
    wminfo->total_mmaps = curproc->num_mmaps;

    for(int i = 0; i < MAX_WMMAP_INFO; i++){
      wminfo->addr[i] = curproc->mmaps[i] -> addr[i];
      wminfo->length[i] = curproc->mmaps[i] -> length[i];
      wminfo->n_loaded_pages[i] = curproc->mmaps[i] -> n_loaded_pages[i];
    }
    return SUCCESS;
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


uint 
sys_wmap(void)
{
	uint addr; // va to (maybe) use  
	int length; // size of mapping
	int flags; // mapping specifications 
	int fd; // file descripter if added 

	// check valid user input 
    if (argint(0, (int *)&addr) < 0 || argint(1, &length) < 0 ||
        argint(2, &flags) < 0 || argint(3, &fd) < 0) {
        return -1;  // if not valid 
    }
    // checks if valid addr 
    int move = 0; // var if the given addr should change

    if(addr%4096!=0) {
    	if(flags &MAP_FIXED)
    		return -1; 
    	int off=4096-addr%4096;
    	addr+=off;	
    }
	if(addr < 0x60000000 || addr > 0x80000000) {
		if(flags &MAP_FIXED)
		    return -1; 
		move = 1; 
	}
	
	// checks if address and length are in range
	if(addr+length > 0x80000000) {
		if(flags & MAP_FIXED)
			return -1; 
		move = 1; 
	}

	// Get the current process
	struct proc *curproc = myproc();
	// get the amount of pages that need to be allocated 
	int numPages = (length+4095)/4096;
//cprintf("pages: %d addr: %x\n",numPages,addr);
	// looks at all mappings already made checking for overlap in memory
	for(int i=0; i<curproc->num_mmaps; i++) {
		if(move == 1) 
			break;
		if((curproc->mmaps[i]->addr[i] <= addr &&
			curproc->mmaps[i]->addr[i]+(curproc->mmaps[i]->length[i]) >= addr) ||
			(curproc->mmaps[i]->addr[i] <= (addr+length) &&
			curproc->mmaps[i]->addr[i]+(curproc->mmaps[i]->length[i]) >= (addr+length))) {
			// if there's overlap and map fixed, return 
			if(flags & MAP_FIXED) 
				return -1;
			move = 1; 
		}
	}
	// checks if the inserted addr is already mapped 
	if(move==0) { 	
//	cprintf("move==0");	 	
		curproc->mmaps[curproc->num_mmaps] = (struct wmapinfo *)kalloc();
		curproc->mmaps[curproc->num_mmaps]->addr[curproc->num_mmaps] = addr;
		curproc->mmaps[curproc->num_mmaps]->length[curproc->num_mmaps] = length;
		curproc->num_mmaps++;
	}else {
//	cprintf("move==1");
		 // look for new addr to map to
		 addr = 0x60000000; // changes addr to start of memory
		 int found = 0; // int checking if a spot in memory is available 
		 //int count = 0;
		 while(addr < 0x80000000) {
		 	if(curproc->num_mmaps==0) {
		 		break;
		 	}
		 	for(int i=0; i<curproc->num_mmaps; i++) {
		 		uint curmap= (uint)curproc->mmaps[i]->addr[i];
		 		if(!((uint)addr == curmap) && !(curproc->mmaps[i]->addr[i] <= addr &&
		 			curproc->mmaps[i]->addr[i]+(curproc->mmaps[i]->length[i]) >= addr) &&
		 			!(curproc->mmaps[i]->addr[i] <= (addr+length) &&
		 			curproc->mmaps[i]->addr[i]+(curproc->mmaps[i]->length[i]) >= (addr+length)) &&
		 			!(curproc->mmaps[i]->addr[i] > (addr) &&
		 					 			curproc->mmaps[i]->addr[i]< (addr+length))) {
		 			// if there's a spot in memory 
		 			found = 1;  
		 		}else {
		 			// if its found the spot is taken, break out of loop 
		 			found = 0;
		 			break;
		 		}
		 	}
		 	if(found == 1) {
		 		// if addr found map it and break out of loop
		 		curproc->mmaps[curproc->num_mmaps] = (struct wmapinfo *)kalloc();
		 		curproc->mmaps[curproc->num_mmaps]->addr[curproc->num_mmaps] = addr;
		 		curproc->mmaps[curproc->num_mmaps]->length[curproc->num_mmaps] = length;
		 		curproc->num_mmaps++; 
		 	//	cprintf("taken %x\n",addr);
		 		break;
		 	}
		 	addr+=0x1000; // increase addr	
		} 
	}
	for(int i=0; i<numPages; i++) {
		char *mem=kalloc(); 
		//if(mem==0){
			// free for loop to i 
	//	}
		// Access the page directory of the current process
		pde_t *pgdir = curproc->pgdir;
//		cprintf("before map: %x\n",addr);
	//	uint naddr=(uint)addr;
	//	void *newaddr = (void *)naddr; //(void*)(va+0x1000*i)
	//	pte_t *pte = (pte_t*)walkpgdir(curproc->pgdir, (void*)&addr+4096*i, 0);
	//	if(!(*pte &PTE_P))
		mappages(pgdir, (void *)(addr + 4096*i), 4096, V2P(mem), PTE_W|PTE_U);

	}
	cprintf("done\n",addr, length);
	return addr;
}

int sys_wunmap(void) {
	uint addr; 
	if (argint(0, (int*)&addr) < 0) {
		return -1; 
	}
	
//	if(addr==0){}
	struct proc *curproc = myproc();
	pde_t *pgdir = curproc->pgdir; 
	// addr thing wrong prob
	pte_t *pte = (pte_t*)walkpgdir(pgdir, (void*)&addr, 0);
	uint physical_address = PTE_ADDR(*pte);
	if(physical_address==0){}
	//	*pte=0;
	//get mapping-> get pde-> pte-> unmap eevrything PTE_U
		//int length = 0;
	// free from wmappings array in proc
	for(int i=0; i<curproc->num_mmaps; i++) {
		if(curproc->mmaps[i]->addr[i] == addr) {
			// free inside pte
			for(int j=0; j<curproc->mmaps[i]->length[i]; j++) {
			//	kfree(P2V(physical_address+4096*i));
			} 
			// move everything at last addr to this addr (so when wmap again wont override current thing)
			if(i == curproc->num_mmaps) {
				myproc()->mmaps[i]=0;
			}else {
				int lastIn = curproc->num_mmaps-1;
				curproc->mmaps[i]->addr[i] = curproc->mmaps[lastIn]->addr[lastIn];
				curproc->mmaps[i]->length[i] = curproc->mmaps[lastIn]->length[lastIn];
			}
			
			myproc()->num_mmaps--;
		//	kfree((char *)curproc->wmappings[i]);
		}
	}
	
	*pte = 0;
	return 0; 
}

uint sys_wremap(void) {
	uint oldaddr;
	int oldsize;
	int newsize;
	int flags; 
	

	if (argint(0, (int*)&oldaddr) < 0 || argint(1, &oldsize) < 0 ||
	        argint(2, &newsize) < 0 || argint(3, &flags) < 0) {
	        return 0;  // if not valid 
	}
	if(oldaddr==0){}
		if(oldsize==0){}
		if(newsize==0){}
		if(flags==0){}

	struct proc *curproc = myproc();
	pde_t *pgdir = myproc()->pgdir; 
	pte_t *pte = (pte_t*)walkpgdir(pgdir, (void*)&oldaddr, 0);
		
	if(oldsize > newsize) {
		if(pte != 0) {
			
					for(int i=0; i<myproc()->num_mmaps; i++) {
						if(myproc()->mmaps[i]->addr[i] == oldaddr) {
							//length = myproc()->wmappings[i]->length;
							// doesnt remove the map pages tho 
							myproc()->mmaps[i]->length[i]=newsize;
							//myproc()->wmapCount--;
							break;
						}
					}
				
		}	
	}else {
		int numPages = (newsize-oldsize+4095)/4096;
		//if(newsize%4096 != 0) 
			//numPages++; 
		if(numPages != 0) {
			 for(int i=0; i<numPages; i++) {
			 		char *mem=kalloc(); 

			 		mappages(pgdir, (void *)(oldaddr+oldsize + 4096*i), 4096, V2P(mem), PTE_W|PTE_U);
			 }
			 for(int i=0; i<myproc()->num_mmaps; i++) {
			 						if(myproc()->mmaps[i]->addr[i] == oldaddr) {
				curproc->mmaps[i]->length[i] = newsize;
			 						}}
		}
	}
//	sys_wunmap(oldaddr);
//	sys_wmap(oldaddr, newsize, flags);
	return oldaddr; 
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
