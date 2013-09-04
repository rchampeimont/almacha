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

#define N 24

int n;
int i, j;
char A[N][N];

void afficherA() {
  for(i=0;i<n;i++) {
    for(j=0;j<n;j++) {
      printf("%c ", A[i][j]);
    }
    printf("\n");
  }
}

void remplirA() {
  for(i=0;i<n;i++) {
    for(j=0;j<n;j++) {
      if (i == 0 || i == n-1 || j == n-1-i) {
	A[i][j] = '*';
      } else {
	A[i][j] = '-';
      }
    }
  }
}

int main()
{

  printf("Entrez la valeur de n : ");
  scanf("%d", &n);

  remplirA();
  afficherA();


  return 0;
}
