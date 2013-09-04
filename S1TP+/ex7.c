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

#define N 2
#define M 3

int A[N][M];
int B[M][N];

int i,j;

void saisirA() {
  for(i=0;i<N;i++) {
    for(j=0;j<M;j++) {
      printf("Entrez la valeur pour A[%d][%d]=", i, j);
      scanf("%d", &A[i][j]);
    }
  }
}

void afficherA() {
  for(i=0;i<N;i++) {
    for(j=0;j<M;j++) {
      printf("%d ", A[i][j]);
    }
    printf("\n");
  }
}

void afficherB() {
  for(i=0;i<M;i++) {
    for(j=0;j<N;j++) {
      printf("%d ", B[i][j]);
    }
    printf("\n");
  }
}

int main()
{
  saisirA();


  for(i=0;i<N;i++) {
    for(j=0;j<M;j++) {
      B[j][i]=A[i][j];
    }
  }

  afficherA();
  afficherB();

  return 0;
}
