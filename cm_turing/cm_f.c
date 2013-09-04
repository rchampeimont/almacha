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
#include "cm_f.h"
#include <stdio.h>
#include <string.h>

int cmAsk(void) {
  int c;
  int r = -1;
  for (;;) {
    /* get all chars of input line */
    while ((c = getchar()) != '\n') {
      if (c == 'y' || c == 'Y') {
	r = 1;
      }
      if (c == 'n' || c == 'N') {
	r = 0;
      }
    }
    /* did we find a 'y' or 'n' in the line? */
    if (r != -1) {
      return r;
    }
    /* no? wait again for 'y' or 'n' */
  }
}

void cmNotEOL(char *s) {
  size_t l;
  if (!s) {
    return;
  }
  l = strlen(s);
  if (l > 0) {
    s[l-1] = '\0';
  }
}

