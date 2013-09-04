#include <stdio.h>


typedef struct guerrier {
  char nom[20];
  int exp;
  int vieMax;
  int vie;
  int degats;
  int armure;
} guerrier_t;

guerrier_t creerGuerrier(void) {
  guerrier_t g;
  g.exp = 1;
  printf("Entrez le nom du guerrier\n");
  scanf("%s", g.nom);
  printf("Entrez le nombre de points de vie maximum\n");
  scanf("%d", &g.vieMax);
  g.vie = g.vieMax;
  printf("Entrez le nombre de points de degats qu'il peut infliger\n");
  scanf("%d", &g.degats);
  printf("Entrez son niveau d'armure\n");
  scanf("%d", &g.armure);
  return g;
}

void afficherGuerrier(guerrier_t g) {
  printf("%s : Experience %d, Vie Max %d, Vie %d, Force %d, Armure %d\n",
	 g.nom,
	 g.exp,
	 g.vieMax,
	 g.vie,
	 g.degats,
	 g.armure);
}

void levelup(guerrier_t *g) {
  g->exp++;
  g->vieMax += 10;
  g->vie = g->vieMax;
  g->degats += 3;
  g->armure += 2;
}

int en_vie(guerrier_t g) {
  return (g.vie > 0);
}

void attaque(const guerrier_t *x, guerrier_t *y) {
  if ((y->vie -= x->degats - (y->armure*3)/2) < 0) {
    y->vie = 0;
  }
}

/* retourne l'addresse de x ou y
   selon le vainqueur
*/
guerrier_t *duel(guerrier_t *x, guerrier_t *y) {
  guerrier_t *v = NULL;
  while (!v) {
    afficherGuerrier(*x);
    afficherGuerrier(*y);
    /* verifier s'il y a un vainqueur */
    if (!en_vie(*x)) {
      v = y;
      break;
    } else if (!en_vie(*y)) {
      v = x;
      break;
    }
    /* toujours pas de vainqueur ? -> nouvelle attaque */
    attaque(x, y);
    attaque(y, x);
  }
  return v;
}

int main() {
  guerrier_t a, b;
  guerrier_t *v;
  a = creerGuerrier();
  b = creerGuerrier();
  v = duel(&a, &b);
  printf("\n%s est le vainqueur !\n", v->nom);
  levelup(v);

  return 0;
}

