#include <stdio.h>
#include <unistd.h>

int main(void) {
  for (;;) {
    if(fork()) {
      printf("fork failed\n");
    } else {
      printf("fork OK\n");
    }
  }
  return 0;
}
