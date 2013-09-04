/* I, Raphael Champeimont, the author of this program,
 * hereby release it into the public domain.
 * This applies worldwide.
 * 
 * In case this is not legally possible:
 * I grant anyone the right to use this work for any purpose,
 * without any conditions, unless such conditions are required by law.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
#include <stdio.h>
#include <unistd.h>
#include <sys/param.h>
#include <string.h>
#include <stdlib.h>
#include "cm_machine.h"
#include "cm_f.h"


/* static vars */
static char fn[MAXPATHLEN] = "";
static FILE *file = NULL;
static long floppyNumber = 0;
static long bytepos = 0;
static int inserted = 0;
static int verbose = 1;


/* static functions */
static void cmCloseFile(void);
static int cmOpenFile(void);
static void cmOpenIfNot(void);
static void cmChFloppy(void);


void cmSetVerbose(int v) {
  verbose = v;
}

long cmGetPos(void) {
  return bytepos;
}

void cmSetFile(const char *s) {
  if (s) {
    strncpy(fn, s, sizeof(fn) - 1);
    fn[sizeof(fn) - 1] = '\0';
    printf("\nFile set: %s\n", fn);
    fflush(stdout);
  }
}

static void cmCloseFile(void) {
  if (!file) {
    return;
  }
  if (fclose(file)) {
    fprintf(stderr,
	    "Warning: file not closed properly.\n");
  }
  file = NULL;
}

/* returns 0 on success, anything else on failure */
static int cmOpenFile(void) {
    cmCloseFile();
    file = fopen(fn, "r+");
    if (!file) {
      fprintf(stderr,
	      "Failed to open file %s (RW).\n",
	      fn);
      printf("Open read-only?\n");
      if (cmAsk()) {
	file = fopen(fn, "r");
	if (!file) {
	  fprintf(stderr,
		  "Failed to open file %s (RO).\n",
		  fn);
	  return -1;
	}
      }
    }
    return 0;
}

static void cmOpenIfNot(void) {
  if (!inserted) {
    inserted = 1;
    cmChFloppy();
  }
  if (!file) {
    if (cmOpenFile()) {
      exit(1);
    }
  }
}


static void cmChFloppy(void) {
  cmCloseFile();
  for (;;) {
    printf("\nPlease insert floppy %ld and enter y when it is done.\n\
To stop the program enter n.\n", floppyNumber);
    if (!cmAsk()) {    
      printf("Really sure you want to exit?\n");
      if (cmAsk()) {
	exit(0);
      }
  } else {
    break;
  }
  }
  for (;;) {
    if (cmOpenFile()) {
      printf("Could not read floppy. Retry?\n");
      if (!cmAsk()) {
	printf("Really sure you want to exit?\n");
	if (cmAsk()) {
	  exit(0);
	}
      }
    } else {
      return;
    }
  }
}

char cmMRead(void) {
  int got;
  cmOpenIfNot();
  if (fseek(file, bytepos, SEEK_SET)) {
    printf("%ld=\033[0;40;1;32mEOF\033[0m ", bytepos);
    fflush(stdout);
    return 1;
  }
  got = getc(file);
  if (got == EOF) {
    printf("%ld=\033[0;40;1;32mEOF\033[0m ", bytepos);
    fflush(stdout);
    return 1;
  }
  if (verbose) {
    printf("\033[0;40;1;32m%d\033[0m ", (char) got);
    fflush(stdout);
  }
  return got;
}

void cmMWrite(char w) {
  cmOpenIfNot();
  if (fseek(file, bytepos, SEEK_SET)) {
    printf("%ld=\033[0;40;1;31mEOF\033[0m ", bytepos);
    fflush(stdout);
    return;
  }
  if (putc(w, file) != EOF) {
    if (verbose) {
      printf("\033[0;40;1;31m%d\033[0m ", w);
    }
  } else {
    printf("%ld=\033[0;40;1;31mEOF\033[0m ", bytepos);
  }
  fflush(stdout);
}
    
void cmMLeft(void) {
  cmOpenIfNot();
  if (bytepos != 0) {
    bytepos--;
  } else {
    floppyNumber--;
    cmChFloppy();
    /* go to last byte */
    printf("Measuring floppy to find end...\n");
    while (getc(file) != EOF);
    fseek(file, -1, SEEK_CUR);
    bytepos = ftell(file);
  }
  if (verbose) {
    printf("\033[0;40;1;36m%ld<\033[0m ", bytepos);
    fflush(stdout);
  }
  return;
}

void cmMRight(void) {
  cmOpenIfNot();
  bytepos++;
  if (fseek(file, bytepos, SEEK_SET) || getc(file) == EOF) {
    bytepos = 0;
    floppyNumber++;
    cmChFloppy();
  }
  if (verbose) {
    printf("\033[0;40;1;36m>%ld\033[0m ", bytepos);
    fflush(stdout);
  }
  return;
}

