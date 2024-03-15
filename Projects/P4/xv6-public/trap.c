#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

pte_t *walkpgdir(pde_t *pgdir, const void *va, int alloc);

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
    case T_PGFLT:
{
    uint fault_addr = rcr2();
    struct proc *p = myproc();
    pte_t *pte = walkpgdir(p->pgdir, (void *)fault_addr, 0);

    if (pte && (*pte & PTE_P) && (*pte & PTE_COW)) {
        // Handle copy-on-write fault
        char *mem = kalloc();
        if (mem == 0) {
            cprintf("Out of memory\n");
            break;
        }
        memmove(mem, (char *)P2V(PTE_ADDR(*pte)), PGSIZE);
        *pte = V2P(mem) | PTE_FLAGS(*pte);
        *pte &= ~PTE_COW;  // Clear COW bit
        *pte |= PTE_W;     // Set write bit
        lcr3(V2P(p->pgdir));  // Flush TLB
        return;  // Handled the page fault
    }

    for (int i = 0; i < MAX_WMMAP_INFO; i++) {
        if (p->mmaps[i].used && fault_addr >= p->mmaps[i].addr &&
            fault_addr < p->mmaps[i].addr + p->mmaps[i].length) {
            // Fault address is part of a mapping
            char *mem = kalloc();
            if (mem == 0) {
                cprintf("Out of memory\n");
                break;
            }
            memset(mem, 0, PGSIZE);

            if (p->mmaps[i].fd != -1) {
                // File-backed mapping
                struct file *f = p->ofile[p->mmaps[i].fd];
                fileseek(f, (fault_addr - p->mmaps[i].addr) + p->mmaps[i].file_offset);
                fileread(f, mem, PGSIZE);
            }

            if (mappages(p->pgdir, (void *)PGROUNDDOWN(fault_addr),
                         PGSIZE, V2P(mem), PTE_W|PTE_U) < 0) {
                kfree(mem);
                cprintf("mappages failed\n");
                break;
            }
            return;  // Handled the page fault
        }
    }

    cprintf("Segmentation Fault\n");
    p->killed = 1;
}
break;
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;
    //page fault
  

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}