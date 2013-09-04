#include <stdio.h>

/* effectue la division de x par y,
   ecrit dans b si la division a ete effectuee (si y != 0)
   et si c'est le cas le resultat dans z */
void division(float x, float y, int *b, float *z) {
  if (y) {
    *b = 1;
    *z = x/y;
  } else {
    *b = 0;
  }
}

int main() {
  float a, b, r;
  int ok;
  printf("Division de a par b, entrez a (reel) :\n");
  scanf("%f", &a);
  printf("Entrez b :\n");
  scanf("%f", &b);
  division(a, b, &ok, &r);
  if (ok) {
    printf("%g/%g = %g\n", a, b, r);
  } else {
    printf("Division par 0 impossible.\n");
  }
  return 0;
}
