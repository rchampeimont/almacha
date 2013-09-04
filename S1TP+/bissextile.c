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

int annee, bissextile;


int main() {

    do {
    printf("Saisissez l'annee dont vous voulez savoir si elle est bissextile ?\n");
    scanf("%d", &annee);
    } while (annee<=0);

    if ( ! ((annee%4) == 0) ) {
        bissextile = 0;
    } else {
        if ( ! ((annee%100) == 0) ) {
            bissextile = 1;
        } else {
            if ( (((annee/1000)*1000)%400) == 0) {
                bissextile = 1;
            } else {
                bissextile = 0;
            }
        }
    }

    if (bissextile == 1) {
        printf("L'annee %d est bissextile.\n", annee);
    } else {
        printf("L'annee %d n'est pas bissextile.\n", annee);
    }


	return 0;
}
