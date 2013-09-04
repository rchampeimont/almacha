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

int Histo[21];
int note_entree;
int i;
int minimum = -1;
int maximum = -1;
int MaNote;
int NNI = 0;

int main()
{
  do {
    printf("Entrez une note ou -1 pour terminer : ");
    scanf("%d", &note_entree);
    if (note_entree != -1)
      {
	if(note_entree>=0 && note_entree <=20){
	  Histo[note_entree]++;
	} else {
	  printf("Note incorrecte !\n");
	}
      }
  } while (note_entree != -1);

  for (i=0; i<=20; i++) {
    if (Histo[i] != 0) {
      minimum = i;
      break;
    }
  }

  if (minimum == -1){
    printf("Erreur : Aucune valeur entree !\n");
    exit(-1);
  }

  printf("Le minium est %d.\n", minimum);

  for (i=20; i>=0; i--) {
    if (Histo[i] != 0) {
      maximum = i;
      break;
    }
  }


  printf("Le maximum est %d.\n", maximum);


  printf("Sasissez votre note : ");
  scanf("%d", &MaNote);

  if (!(MaNote>=0 && MaNote <=20)) {
    printf("Votre note est incorrecte !\n");
    exit(-1);
  }

  if (Histo[MaNote] == 0) {
    printf("Votre note n'est pas dans la liste !\n");
    exit(-1);
  }

  for (i=0; i<=MaNote; i++) {
    NNI = NNI + Histo[i];
  }
  NNI = NNI - 1;

  printf("Il y a %d personnes qui ont eu une note inferieur ou egale a la votre.\n", NNI);




  return 0;
}
