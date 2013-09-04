#include <stdio.h>
#include <stdlib.h>

/* echange les entiers a et b */
void echange(int *a, int *b) {
  int tmp;
  tmp = *a;
  *a = *b;
  *b = tmp;
}

/* effectue une etape elementaire du calcul
   du PGCD */
void etape_elementaire(int *n, int *k) {
  if (*n < *k) {
    echange(n, k);
  }
  *n -= *k;
}

/* calcule et retourne le PGCD de n et k */
int pgcd(int n, int k) {
  /* si n est nul, le PGCD est k */
  if (!n) {
    return k;
  }
  /* si k est nul, le PGCD est n */
  if (!k) {
    return n;
  }
  while (n != k) {
    /* a chaque passage dans la boucle,
       on calcule pgcd(n,k) */
    etape_elementaire(&n, &k);
  }
  return n;
}

int main() {
  int a, b, p;
  printf("Ce programme calcule le PGCD de a et b.\n\
Entrez a :\n");
  scanf("%d", &a);
  printf("Entrez b :\n");
  scanf("%d", &b);
  p = pgcd(a, b);
  printf("pgcd(%d,%d) = %d\n", a, b, p);
  return 0;
}
