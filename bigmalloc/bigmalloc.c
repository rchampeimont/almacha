/* This is a program to test how much memory you can allocate
   with malloc */

#include <stdio.h>
#include <stdlib.h>

int main(void) {
  unsigned long size = 0;
  while (malloc(1024*1024)) {
    printf("%lu MB allocated.\n", ++size);
  }
  printf("Failed to allocate more memory.\n");
  return 0;
}
