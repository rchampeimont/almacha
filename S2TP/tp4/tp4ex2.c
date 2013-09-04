#include <stdio.h>
#include <string.h>

/* retourne le nombre d'occurences de motif dans s,
   en acceptant les recouvrements */
unsigned long compterAR(const char *s, const char *motif) {
  size_t i, j;
  unsigned long ret = 0;
  int trouve;
  for (i=0; i < strlen(s) - strlen(motif); i++) {
    trouve = 1;
    for (j=i; j < strlen(motif); j++) {
      if (*(s+j) != *(motif+j)) {
	trouve = 0;
	break;
      }
    }
    if (trouve) {
      ret++;
    }
  }
  return ret;
}


int main() {
  char s[10], m[10];
  printf("Entrez la chaine :\n");
  fgets(s, sizeof(s), stdin);
  s[strlen(s)-1] = '\0';

  printf("Entrez le motif :\n");
  fgets(m, sizeof(m), stdin);
  m[strlen(m)-1] = '\0';

  printf("Le motif %s apparait %lu fois.\n",
	 m, compterAR(s, m));

  return 0;
}
