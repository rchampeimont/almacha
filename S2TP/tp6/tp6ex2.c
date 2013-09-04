#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

char *genstring(void) {
  char *p;
  size_t i;
  size_t size;
  if (!(p = malloc(size = 100))) {
    return NULL;
  }
  for (i=0; i<size-1; i++) {
    *(p+i) = rand()%(26) + 'a';
  }
  *(p+size-1) = '\0';
  return p;
}

int *maketable(char *s) {
  int *p;
  size_t i, j;
  size_t size;
  if (!s) {
    return NULL;
  }
  
  if (!(p = malloc(size = 26))) {
    return NULL;
  }
  for (i=0; i<size; i++) {
    *(p+i) = 0;
    for (j=0; j<strlen(s); j++) {
      if (*(s+j) == 'a' + i) {
	(*(p+i))++;
      }
    }
  }
  return p;
}

char charoc(int *t)
{
  size_t i;
  size_t max = 0;
  for (i=0; i<26; i++) {
    if (*(t+i) >= max) {
      i = max;
    }
  }
  return max + 'a';
}

int main(void) {
  char *s = NULL;
  srand(time(NULL));
  printf("%s\n", s = genstring());
  


  free(s);
  s = NULL;
  return 0;
}
