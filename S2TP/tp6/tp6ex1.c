#include <stdio.h>

typedef struct tableau {
  int longueur;
  int T[100];
} tableau_t;

int seq(int n, tableau_t t) {
  int i;
  for (i=0; i<t.longueur; i++) {
    if (t.T[i] == n) {
      return i;
    } else if (n < t.T[i]) {
      return -1;
    }
  }
  return -1;
}

int dic(int n, tableau_t t) {
  int i, a, b;
  a = 0;
  b = t.longueur-1;
  i = (b+a)/2;

  do {
    if (t.T[i] < n) {
      a = i+1;
    } else {
      b = i;
    }
    i = (b+a)/2;
  } while(a<b);

  if (t.T[i] == n) {
    return i;
  }

  return (-1);
}

int main(void) {
  tableau_t t;
  int n;
  t.longueur = 7;
  t.T[0] = -40;
  t.T[1] = -5;
  t.T[2] = 7;
  t.T[3] = 23;
  t.T[4] = 48;
  t.T[5] = 72;
  t.T[6] = 120;
  printf("Entrez un entier\n");
  scanf("%d", &n);
  printf("Position de l'entier dans le tableau (-1 si non present) :\n");
  printf("D'après la recherche sequentielle : %d\n", seq(n, t));
  printf("D'après la recherche dichotomique : %d\n", dic(n, t));
  return 0;
}
