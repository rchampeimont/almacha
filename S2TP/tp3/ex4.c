#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stddef.h>

/* retourne le caractere c decale de 3 rangs */
char decalage(char c) {
  /* si c est une minuscule */
  if (c >= 'a' && c <= 'z') {
    return (c - 'a' + 3)%26 + 'a' ;
  }
  /* si c est une majuscule */
  if (c >= 'A' && c <= 'Z') {
    return (c - 'A' + 3)%26 + 'A' ;
  }
  /* si c n'est ni l'un ni l'autre,
     on retourne c sans le modifier */
  return c;
}

/* code la chaine s avec le code de Cesar */
void cesar(char *s) {
  char *dernierChar;
  char *i;
  dernierChar = s + strlen(s) - 1;
  for (i=s; i<=dernierChar; i++) {
    *i = decalage(*i);
  }
}

int main() {
  char texte[10];
  fgets(texte, sizeof(texte), stdin);
  cesar(texte);
  printf("%s\n", texte);
  return 0;
}
