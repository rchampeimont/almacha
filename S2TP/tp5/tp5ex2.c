#include <stdio.h>

typedef struct droite {
  float a;
  float b;
  float c;
} droite_t;

droite_t saisirDroite(void) {
  droite_t ret;
  printf("Definition d'une droite d'equation y=ax+by+c\n");
  printf("a = ");
  scanf("%f", &ret.a);
  printf("b = ");
  scanf("%f", &ret.b);
  printf("c = ");
  scanf("%f", &ret.c);
  return ret;
}

int paralleles(droite_t d1, droite_t d2) {
  return (d1.a*d2.b == d2.a*d1.b);
}

int main() {
  if (paralleles(saisirDroite(), saisirDroite())) {
    printf("Les droites sont paralleles.\n");
  } else {
    printf("Les droites ne sont pas paralleles.\n");
  }
  return 0;
}
