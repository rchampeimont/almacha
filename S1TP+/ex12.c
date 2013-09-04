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

int a, b, N, P, al_r, al_a, al_b;
float f;

int main()
{
  P = 0;
  printf("a,b seront entre 1 et N, entrez N:");
  scanf("%d", &N);
  for(a=1; a<=N; a++) {
    for(b=1; b<=N; b++) {
      /* Algorithme d'Euclide */
      al_a = a;
      al_b = b;
      al_r = al_b;
      al_b = al_a;
      while(al_r != 0) {
	al_a = al_b;
	al_b = al_r;
	al_r = al_a%al_b;
      }
      /* on a ici al_b = dernier reste non nul */
      if (al_b == 1) {
	P++;
      }
      //printf("pgcd=(%d,%d)=%d  [on a %d couples]\n", a, b, al_b, P);
    }
  }
  printf("\nLe nombre de couples est %d.\n", P);
  f = ((float)P)/((float)(N*N));
  printf("\nLe rapport P/(N^2) vaut %g.\n", f);
  return 0;
}
