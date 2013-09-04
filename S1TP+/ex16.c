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
#include <math.h>

#define N 1000

int crible[N+1]; /* 1 = premier ; 0 = non premier */

void mettreCribleVrai() {
  int i;
  for (i=0; i<=N; i++) {
    crible[i] = 1;
  }
}

void trouverMultiples(int n) {
  int i;
  int produit;
  i = 2;
  produit = i*n;
  while (produit<=N) {
    crible[i*n] = 0;
    i++;
    produit = i*n;
  }
}

int main() {
  int k, l;


  mettreCribleVrai();

  crible[0] = 0;
  crible[1] = 0;

  for (k=2; k<N; k++) {
    if (crible[k] == 1) {
      printf("On cherche les multiples de %d...\n", k);
      trouverMultiples(k);
    }
  }

  for (l=0; l<=N; l++) {
    if (crible[l] == 1) {
      printf("%d ", l);
    }
  }


  return 0;
}
