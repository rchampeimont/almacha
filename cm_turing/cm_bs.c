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
#include "cm_bs.h"
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

/* this is not a real bubblesort, it is just some
   other stupid algo */
void cmAlgoBubbleSort(void) {
  unsigned long i, j, n;
  char a, b;
  int end;
  int v;

  printf("Sort a infinite number of bytes?\n");
  if (!cmAsk()) {
    printf("Sort how many bytes?\n");
    scanf("%lu", &n);
  } else {
    n = ULONG_MAX;
  }
  printf("n=%lu\n", n);
  
  printf("Print how many bytes are sorted?\n");
  v = cmAsk();

  for (i=1, cmMRight(); ; i++, cmMRight()) {
    end = 0;
    for (j=i; j>0; ) {
      b = cmMRead();
      cmMLeft();
      a = cmMRead();
      if (a > b) {
	cmMWrite(b);
	cmMRight();
	cmMWrite(a);
	cmMLeft();
      } else {
	end = 1;
      }
      j--;
      if (end) {
	break;
      }
    }
    while (j<i) {
      j++;
      cmMRight();
    }
    if (v) {
      printf("%lu sorted bytes\n", i+1);
    }
    if (i+1 == n) {
      printf("\nAll requested bytes were sorted.\n");
      exit(0);
    }
  }
}

void cmAlgoCheckSort(void) {
  char a, b;
  b = cmMRead();
  for (;;) {
    a = b;
    cmMRight();
    b = cmMRead();
    if (a > b) {
      printf("\nFirst not sorted byte: %ld\n", cmGetPos());
      exit(0);
    }
  }
}
