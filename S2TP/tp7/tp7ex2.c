#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* structure pour stocker les
   infos sur un etudiant */
typedef struct et {
  int numero;
  char nom[20];
  struct et *suiv;
} et_t;


/* cree un nouvel element de type et_t
   avec comme valeurs celle donnes
   en parametres
   
   retourne NULL en cas d'echec ou un
   pointeur vers la structure alloue sinon
*/
et_t *creer(const char *nom, int numero) {
  et_t *retour;
  
  retour = malloc(sizeof(et_t));

  /* en cas d'echec du malloc() */
  if (!retour) {
    return NULL;
  }

  /* copie du numero d'etudiant */
  retour->numero = numero;
  /* on met suiv a NULL */
  retour->suiv = NULL;
  /* on ne copie pas le nom si
     c'est un pointeur NULL */
  if (nom) {
    /* copie du nom */
    strncpy(retour->nom, nom, sizeof(retour->nom) - 1);
    /* on s'assure que le nom se termine par un '\0' */
    *(retour->nom + sizeof(retour->nom) - 1) = '\0';
  } else {
    /* on a nom == NULL, dans ce
       cas on ecrit une chaine vide */
    *(retour->nom) = '\0';
  }
  return retour;
}

/* insere un element en tete de liste,
   retourne NULL en cas d'echec
   ou la nouvelle tete de liste en cas de succes
*/
et_t *inserer(const char *nom, int numero, et_t *tete) {
  et_t *nouveau;

  nouveau = creer(nom, numero);

  if (!nouveau) {
    return NULL;
  }

  /* on fait pointer nouveau->suiv
     vers l'ancienne tete de liste */
  nouveau->suiv = tete;

  /* on retourne la nouvelle tete,
     c'est-a-dire l'adresse du nouvel element
  */
  return nouveau;
}

/* chercher une etudiant dont le numero
   est numero, dans la liste pointee par tete

   un pointeur vers l'element trouve est
   retourne, ou NULL si on n'a pas trouve
*/
et_t *chercher(int numero, et_t *tete) {
  /* tant qu'on a un pointeur non NULL */
  while (tete) {
    if (tete->numero == numero) {
      /* on a trouve */
      return tete;
    }
    /* on passe a l'element suivant
       (qui n'existe pas forcement,
       dans ce cas on a NULL) */
    tete = tete->suiv;
  }
  /* on a pas trouve -> on retourne NULL */
  return NULL;
}

/* supprimer l'etudiant de numero
   numero

   tete est un pointeur vers
   le pointeur contenant la 1ere adresse

   la fonction retourne 0 si et seulement
   si la suppression a reussi
*/
int supprimer(int numero, et_t **tete) {
  et_t *i = NULL;
  et_t *prec = NULL;
  
  /* si tete est NULL on ne fait rien
     (simple verification) */
  if (!tete) {
    return -1;
  }

  /* on fait pointer i vers le 1er element */
  i = *tete;
  
  /* tant que i est non-NULL */
  while (i) {
    if (i->numero == numero) {
      /* on a trouve l'element a supprimer */
      /* 2 cas : */
      if (!prec) {
	/* cas 1 : il n'y a pas d'element precedent,
	   autrement dit on a i == *tete (prec == NULL) ;
	   dans ce cas on change simplement la tete */
	*tete = i->suiv;
	/* et on detruit i */
	free(i);
	i = NULL;
	/* on retourne -> succes */
	return 0;
      } else {
	/* 2e cas : on a un element precedent :
	   on fait pointer prec->suiv sur
	   i->suiv pour que i soit "saute" */
	prec->suiv = i->suiv;
	/* et on detruit i */
	free(i);
	i = NULL;
	/* on retourne -> succes */
	return 0;
      }
    }
    /* on memerise l'adresse de l'element courant
       (qui va devenir le precedent) */
    prec = i;
    /* on passe a l'element suivant */
    i = i->suiv;
  }
  
  /* i == NULL -> on a pas trouve -> echec */
  return -1;

}

void afficher(const et_t *tete) {
  printf("Liste :\n");
  while (tete) {
    printf("Nom : >%s<\tNumero : %d\n",
	   tete->nom,
	   tete->numero);
    tete = tete->suiv;
  }
  printf("Fin de la liste.\n");
}

/* supprime le dernier caractere de la chaine
   s si c'est un '\n' */
char *chomp(char *s) {
  size_t len;
  if (s) {
    len = strlen(s);
    if (len > 0) {
      if (*(s+len-1) == '\n') {
	*(s+len-1) = '\0';
      }
    }
  }
  return s;
}

int main(void) {
  et_t *tete = NULL;
  et_t *tmp = NULL;
  char nom[100];
  int numero;
  int action;

  for (;;) {
    printf("\nQue voulez-vous faire ?\n\
0 - quitter\n\
1 - insere un etudiant\n\
2 - effacer un etudiant\n\
3 - afficher la liste des etudiants\n");
    scanf("%d", &action);
    while (getchar() != '\n');
    printf("\n");
    switch (action) {
    case 0:
      exit(0);
      break;
    case 1:
      printf("Entrez le nom de l'etudiant (max 20 chars) :\n");
      chomp(fgets(nom, sizeof(nom), stdin));
      printf("Entrez le numero de l'etudiant %s :\n", nom);
      scanf("%d", &numero);
      while (getchar() != '\n');
      if (! (tmp = inserer(nom, numero, tete))) {
	printf("\nErreur lors de l'insertion\n");
      } else {
	tete = tmp;
      }
      break;
    case 2:
      printf("Entrez le numero de l'etudiant :\n");
      scanf("%d", &numero);
      while (getchar() != '\n');
      if (supprimer(numero, &tete)) {
	printf("\nErreur lors de la suppression.\n");
      }
      break;
    case 3:
      afficher(tete);
      break;
    default:
      printf("Action non reconnue.\n");
      break;
    }
  }



  return 0;
}
