//#include "spinlock.h" 
typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;
typedef uint pde_t;

#ifndef __SPINKLOCK__
#define __SPINKLOCK__
// Mutual exclusion lock.
struct spinlock {
  uint locked;       // Is the lock held?

  // For debugging:
  char *name;        // Name of lock.
  struct cpu *cpu;   // The cpu holding the lock.
  uint pcs[10];      // The call stack (an array of program counters)
                     // that locked the lock.
};

#endif
typedef struct {
  // Lock state, ownership, etc.
  uint locked;       // Is the lock held?
  struct spinlock sl; // spinlock protecting this sleep lock
  int pid;           // Process holding lock
} mutex;
