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

#define N 7

int t[N] = {55, 4, 8, 13, 43, 89, 44};

void Echange(int i, int j) {
    int k;
    k = t[i];
    t[i] = t[j];
    t[j] = k;
}

int TriSelection(int a, int b) {
    return (a>b);
}

int main()
{
  int min, i, j;
  min = 0;
  for (i=0;i<N-1;i++) {
    min = i;
    for (j=i+1;j<N;j++) {
      if (TriSelection(t[j], t[min])) {
	min = j;
      }
    }
    Echange(i, min);
  }

  for (i=0; i<N; i++) {
    printf("t[%d]=%d\n", i, t[i]);
  }

  return 0;
}
