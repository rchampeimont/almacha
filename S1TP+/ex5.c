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

void Action1(int a) {
    printf("\n%dx2=%d\n\n", a, a*2);
}

void Action2() {
    printf("Je suis la fonction Action2 !\n");
}

int menu() {
  int a;
  int b;
  
  while (1) {
    
    do {
      printf("-0- Sortir\n-1- Action1\n-2- Action2\n");
      scanf("%d", &a);
    } while(a < 0 || a > 2);
    
    switch(a) {
    case 0:
      return 0;
    case 1:
      do {
	printf("Entrez un nombre entre 0 et 100\n");
	scanf("%d", &b);
      } while(b < 0 || b > 100);
      Action1(b);
      break;
    case 2:
      Action2();
      break;
    }
    
  }
  
}

int main()
{
	printf("%d\n", menu());
	return 0;
}
