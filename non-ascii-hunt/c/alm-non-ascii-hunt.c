/* By Almacha, in the public domain. */
/* Note: A C# version of the same program is in ../cs/. */

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv) {
  int c = EOF;
  FILE *f = NULL;
  int fromfile = 0;
  unsigned long count = 0;

  if (argc >= 2) {
    if (!(f = fopen(*(argv+1), "rb"))) {
      fprintf(stderr, "Cannot open file %s.\n", *(argv+1));
      exit(1);
    }
    fromfile = 1;
  } else {
    f = stdin;
  }

  while ((c = getc(f)) != EOF) {
    if ((c >= 0x20 && c <= 0x7e) || c == '\n' || c == '\t' || c == '\r') {
      putchar(c);
    } else {
      count++;
      printf("\033[1;37;41m\\x%02x\033[0m",
	  (unsigned int) ((unsigned char) c));
    }
  }
  if (count) {
    printf("\033[1;37;41mReport: %lu non-printable ASCII chars found.\033[0m\n",
	count);
  } else {
    printf("\033[1;37;42mReport: No non-printable ASCII chars found.\033[0m\n");
  }

  if (fromfile) {
    fclose(f);
  }
  return 0;
}
