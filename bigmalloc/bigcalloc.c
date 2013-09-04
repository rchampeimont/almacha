/* This is a program to test how much memory you can allocate
 * (and "really" allocate - no lazily)
 * with calloc */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
  unsigned long size = 0;
  char *p;
  while ((p = calloc(1024,1024))) {
    printf("%lu MB allocated.\n", ++size);
    memset(p,0x42,1024*1024);
  }
  printf("Failed to allocate more memory.\n");
  return 0;
}
