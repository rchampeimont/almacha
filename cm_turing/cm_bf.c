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
#include "cm_bf.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stddef.h>
#include <sys/param.h>
#include <string.h>
#include <limits.h>
#include <stdarg.h>
#include "cm_f.h"
#include "cm_algo.h"
#include "cm_machine.h"

static void printBF(const char *s, ...) {
  va_list ap;
  va_start(ap, s);
  if (s) {
    printf("\033[0;40;33;1m");
    vprintf(s, ap);
    printf("\033[0m");
  }
  fflush(stdout);
  va_end(ap);
}

static void putBF(int c, FILE *out) {
  fprintf(out, "\033[0;40;35;1m");
  if ((c >= ' ' && c <= '~')) {
    fprintf(out, "\'%c\'", (char) c);
  } else if (c == '\n') {
    fprintf(out, "LF");
  } else {
    fprintf(out, "%d", (char) c);
  }
  fprintf(out, "\033[0m ");
  fflush(out);
}

void cmAlgoFuck(void) {
  char *code = NULL;
  size_t size;
  char c;
  char *ins;
  FILE *fuckout;
  FILE *fuckin;
  FILE *fuckrand;
  char fn[MAXPATHLEN];
  int color = 0;
  int alcont = 0;
  unsigned long count;
  int randAllowed = 0;

  printf("Use /dev/arandom as fuckrand?\n");
  if (cmAsk()) {
    strncpy(fn, "/dev/arandom", sizeof(fn) - 1);
    fn[sizeof(fn)-1] = '\0';
  } else {
    printf("Other possibility: Use /dev/urandom as fuckrand?\n");
    if (cmAsk()) {
      strncpy(fn, "/dev/urandom", sizeof(fn) - 1);
      fn[sizeof(fn)-1] = '\0';
    } else {
      printf("Enter output file:\n");
      fgets(fn, sizeof(fn), stdin);
      cmNotEOL(fn);
    }
  }
  fuckrand = fopen(fn, "r");
  if (!fuckrand) {
    fprintf(stderr,
	    "Fatal: could not open file: %s\n", fn);
    exit(1);
  }
  

  printf("Use stdout as fuckout?\n");
  if (cmAsk()) {
    fuckout = stdout;
  } else {
    printf("Enter output file:\n");
    fgets(fn, sizeof(fn), stdin);
    cmNotEOL(fn);
    fuckout = fopen(fn, "a");
    if (!fuckout) {
      fprintf(stderr,
	      "Fatal: could not open file: %s\n", fn);
      exit(1);
    }
  }

  printf("Use color on output (BF)?\n");
  color = cmAsk();

  printf("Use stdin as fuckin?\n");
  if (cmAsk()) {
    fuckin = stdin;
  } else {
    printf("Enter input file:\n");
    fgets(fn, sizeof(fn), stdin);
    cmNotEOL(fn);
    fuckin = fopen(fn, "r");
    if (!fuckin) {
      fprintf(stderr,
	      "Fatal: could not open file: %s\n", fn);
      exit(1);
    }
  }

  printf("Always continue?\n");
  alcont = cmAsk();

  printf("Ext: Consider ! as set to a random value?\n");
  randAllowed = cmAsk();

  for (;;) {
    
    if (!alcont) {
      printBF("\nContinue? ");
      if (!cmAsk()) {
	break;
      }
    }
    
    free(code);
    code = NULL;
    size = 0;
    
    printBF("ReadingCode(at%ld) ", cmGetPos());
    code = malloc(size = 1);
    if (!code) {
      fprintf(stderr,
	      "malloc failed\n");
      exit(1);
    }
    *code = 'B';
    for (;;) {
      code = realloc(code, ++size);
      if (!code) {
      fprintf(stderr,
	      "realloc failed\n");
      exit(1);
      }
      c = *(code+size-1) = cmMRead();
      cmMRight();
      if (c == 'B') {
	break;
      }
    }


    printBF("ExecutingCode(%luB) ",
	    (unsigned long) size);
    for (ins = code+1; *ins != 'B'; ins++) {
      switch (*ins) {
      case '>':
	printBF("> ");
	cmMRight();
	break;
      case '<':
	printBF("< ");
	cmMLeft();
	break;
      case '+':
	printBF("+ ");
	c = cmMRead();
	if (c == CHAR_MAX) {
	  cmMWrite(CHAR_MIN);
	} else {
	  cmMWrite(c+1);
	}
	break;
      case '-':
	printBF("- ");
	c = cmMRead();
	if (c == CHAR_MIN) {
	  cmMWrite(CHAR_MAX);
	} else {
	  cmMWrite(c-1);
	}
	break;
      case ',':
	printBF(", ");
	cmMWrite(getc(fuckin));
	break;
      case '!':
	if (randAllowed) {
	  printBF("! ");
	  if (getc(fuckrand) == 42) {
	    cmMWrite((char) getc(fuckrand));
	  }
	  break;
	}
	break;
      case '.':
	printBF(". ");
	if (color) {
	  putBF(cmMRead(), fuckout);
	} else {
	  putc(cmMRead(), fuckout);
	}
	break;
      case '[':
	printBF("[ ");
	if (!cmMRead()) {
	  count = 0;
	  while (*ins != 'B') {
	    ins++;
	    if (*ins == '[') {
	      count++;
	    }
	    if (*ins == ']') {
	      if (!count) {
		break;
	      } else {
		count--;
	      }
	    }
	  }
	  if (*ins == ']') {
	    printBF("to] ");
	  }
	}
	break;
      case ']':
	printBF("] ");
	if (cmMRead()) {
	  count = 0;
	  while (*ins != 'B') {
	    ins--;
	    if (*ins == ']') {
	      count++;
	    }
	    if (*ins == '[') {
	      if (!count) {
		break;
	      } else {
		count--;
	      }
	    }
	  }
	  if (*ins == '[') {
	    printBF("backto[ ");
	  }
	}
	break;
      default:
	break;
      }

      /* check if we have reached end */
      if (*ins == 'B') {
	break;
      }
    }
    
    if (ins == code) {
      printBF("End(AtBegin) ");
    } else {
      printBF("End ");
    }
    
  }
  
  return;
}
