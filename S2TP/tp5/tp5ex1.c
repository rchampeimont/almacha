#include <stdio.h>
#include <stdlib.h>

typedef struct trainRER {
  char ligne; /* A,B,C,D,E */
  int heure; /* heure de depart 8h10 = 810 */
  char direction[32]; /* "Robinson", "Mitry", ... */
  unsigned int longueur; /* longueur du train (voitures) */
} trainRER_t;

int main() {
  trainRER_t x;
  printf("Entrez la ligne : ");
  x.ligne = getchar();
  printf("l'heure de depart : ");
  scanf("%d", &x.heure);
  printf("Direction : ");
  scanf("%s", x.direction);
  printf("Longueur du train : ");
  scanf("%u", &x.longueur);
  printf("Train de la ligne %c part a %02dh%02d en direction de %s, \
%u voitures\n",
	 x.ligne, x.heure/100, x.heure%100, x.direction, x.longueur);
  
  return 0;
}
