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
#include <stdlib.h>
#include "cm_machine.h"
#include "cm_f.h"
#include "cm_algo.h"
#include "cm_bf.h"
#include "cm_bs.h"

void cmBye(void) {
  printf("Bye.\n");
}

int main(int argc, char **argv) {
  atexit(cmBye);
  if (argc < 2) {
    fprintf(stderr,
	    "Please give a file path corresponding \
to the floppy device node.\n");
  return 1;
  }
  cmSetFile(*(argv+1));

  printf("Verbose (machine)?\n");
  cmSetVerbose(cmAsk());

  printf("Algo:\n");
  printf("Brainfuck?\n");
  if (cmAsk()) {
    cmAlgoFuck();
    return 0;
  }

  printf("BubbleSort?\n");
  if (cmAsk()) {
    cmAlgoBubbleSort();
    return 0;
  }

  printf("CheckSort?\n");
  if (cmAsk()) {
    cmAlgoCheckSort();
    return 0;
  }

  printf("Manual mode?\n");
  if (cmAsk()) {
    cmAlgoMan();
    return 0;
  }

  printf("Stupid algo?\n");
  if (cmAsk()) {
    cmAlgo1();
    return 0;
  }
  
  



  return 0;
}
