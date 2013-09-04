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

int somme_versee, prix, difference, reste, nb5e, nb2e, nb1e, nb50c, nb20c, nb10c, nb1c;

int main()
{
  printf("Entrez le prix en centimes : ");
  scanf("%d", &prix);
  printf("Entrez la somme payee en centimes : ");
  scanf("%d", &somme_versee);
  difference=somme_versee-prix;

  if (difference <=0) {
    printf("Il ne faut rien rendre.\n");
    return 0;
  }


  nb5e=difference/500;
  reste=difference%500;
  nb2e=reste/200;
  reste=reste%200;
  nb1e=reste/100;
  reste=reste%100;
  nb50c=reste/50;
  reste=reste%50;
  nb20c=reste/20;
  reste=reste%20;
  nb10c=reste/10;
  nb1c=reste%10;

  printf("Il faut rendre :\n");

  if (nb5e>0) {
    if (nb5e > 1) {
      printf(" - %d billets de 5 E\n", nb5e);
    } else {
      printf(" - 1 billet de 5E\n");
    }
  }
  if (nb2e>0) {
    printf(" - %d pieces de 2 E\n", nb2e);
  }
  if (nb1e>0) {
    printf(" - %d pieces de 1 E\n", nb1e);
  }
  if (nb50c>0) {
    printf(" - %d pieces de 50 c\n", nb50c);
  }
  if (nb20c>0) {
    printf(" - %d pieces de 20 c\n", nb20c);
  }
  if (nb10c>0) {
    printf(" - %d pieces de 10 c\n", nb10c);
  }
  if (nb1c>0) {
    printf(" - %d pieces de 1c ", nb1c);
  }

  return 0;
}
