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
#include <time.h>

unsigned int a, n, e;

int main()
{

  //srand(time(NULL));

  a = rand()%1000;

  e = 1;

  printf("Entrez un nombre entre 0 et 1000 : ");
  scanf("%u", &n);

  while (n != a) {
    e++;
    if (n>a) {
      printf("Moins !\n");
    } else {
      printf("Plus !\n");
    }
    printf("Re-essayez : ");
    scanf("%u", &n);
  }

  printf("Gagne !  au bout de %d essais\n", e);

  return 0;
}
