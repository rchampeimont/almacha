#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef struct cp {
  float a;
  float b;
} cp_t;

cp_t ab2cp(float a, float b) {
  cp_t ret;
  ret.a = a;
  ret.b = b;
  return ret;
}

cp_t saisirComplexe(void) {
  float a, b;
  cp_t z;
  printf("Entrez un reel a\n");
  scanf("%f", &a);
  printf("Entrez un reel b\n");
  scanf("%f", &b);
  z = ab2cp(a, b);
  return z;
}

void afficherComplexe(cp_t z) {
  printf("%g + %gi\n", z.a, z.b);
}

cp_t addition(cp_t c, cp_t d) {
  cp_t z;
  z.a = c.a + d.a;
  z.b = c.b + d.b;
  return z;
}

cp_t oppose(cp_t z) {
  z.a = -z.a;
  z.b = -z.b;
  return z;
}

cp_t multi(cp_t c, cp_t d) {
  cp_t z;
  z.a = c.a * d.a - c.b * d.b;
  z.b = c.a * d.b + d.a * c.b;
  return z;
}

float module(cp_t z) {
  return (sqrt(z.a*z.a + z.b*z.b));
}

float dansDisque(cp_t point, float rayon, cp_t centre) {
  return (module(addition(point, oppose(centre))) <= rayon);
}

int main() {
  cp_t z1, z2;
  float r;
  
  printf("Saisie d'un nombre complexe z1\n");
  z1 = saisirComplexe();
  afficherComplexe(z1);

  printf("Saisie d'un nombre complexe z2\n");
  z2 = saisirComplexe();
  afficherComplexe(z2);

  printf("z1 + z2 = ");
  afficherComplexe(addition(z1, z2));

  printf("z1 * z2 = ");
  afficherComplexe(multi(z1, z2));
  
  printf("Entrez un rayon pour le disque\n");
  scanf("%f", &r);
  printf("z1 %s dans le disque de centre z2 et de rayon r.\n",
	 dansDisque(z1, r, z2) ? "est" : "n'est pas");
  


  return 0;
}
