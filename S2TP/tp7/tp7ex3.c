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



/* inserer un etudiant au bon endroit

   tete est un pointeur vers
   le pointeur contenant la 1ere adresse

   la fonction retourne 0 si et seulement
   si l'insertion a reussi
*/
int inserer(const char *nom, int numero, et_t **tete) {
  et_t *i = NULL;
  et_t *prec = NULL;
  et_t *nouveau = NULL;

  /* si tete est NULL on ne fait rien
     (simple verification) */
  if (!tete) {
    return -1;
  }

  nouveau = creer(nom, numero);
  if (!nouveau) {
    return -1;
  }
  
  /* on fait pointer i vers le 1er element */
  i = *tete;
  
  /* tant que i est non-NULL */
  while (i) {
    if (i->numero >= numero) {
      /* on a trouve l'element qui va suivre */
      /* 2 cas : */
      if (!prec) {
	/* cas 1 : il n'y a pas d'element precedent,
	   autrement dit on a i == *tete (prec == NULL) ;
	   dans ce cas on ajoute l'element en tete */
	*tete = nouveau;
      } else {
	/* 2e cas : on a un element precedent :
	   on fait pointer prec->suiv sur
	   nouveau */
	prec->suiv = nouveau;
      }
      /* dans tous les cas on fait pointer
	 nouveau->suiv sur l'element suivant */
      nouveau->suiv = i;
      return 0;
    }
    /* on memerise l'adresse de l'element courant
       (qui va devenir le precedent) */
    prec = i;
    /* on passe a l'element suivant */
    i = i->suiv;
  }

  /* 2 cas : 1. on a aucun element */
  if (!*tete) {
    *tete = nouveau;
    return 0;
  }

  /* 2. on est arrive au bout,
     l'element est a placer a la fin */
  prec->suiv = nouveau;
  return 0;
  
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



/* fusionne a et b puis les detruit */
et_t *fusionner(et_t *a, et_t *b) {
  et_t *f = NULL;
  et_t *src = NULL;
  /* at et bt servent a parcourir a et b */
  et_t *at = a;
  et_t *bt = b;
  et_t *z = NULL;
  
  for (;;) {
    if (!at && !bt) {
      /* si on est au bout de at et bt
	 on a fini */
      break;
    }
    if (!at) {
      /* plus rien dans a? on prend dans b */
      src = bt;
      /* suivant (pour apres) */
      bt = bt->suiv;
    } else if (!bt) {
      /* l'inverse */
      src = at;
      at = at->suiv;
    } else {
      /* il en reste dans les deux :
	 on compare et on choisit */
      if (at->numero < bt->numero) {
	src = at;
	at = at->suiv;
      } else {
	src = bt;
	bt = bt->suiv;
      }
    }
    /* on insere l'element choisi */
    inserer(src->nom, src->numero, &f);
  }

  /* on detruit a et b */
  while (a) {
    z = a->suiv;
    free(a);
    a = z;
  }
  while (b) {
    z = b->suiv;
    free(b);
    b = z;
  }

  return f;
}



int main(void) {
  /* 2 listes : */
  et_t *listes[2] = {NULL, NULL};
  et_t *tete = NULL;
  char nom[100];
  int numero;
  int action;
  int l = 0;

  for (;;) {
    /* on met a jour listes[l] */
    listes[l] = tete;
    
    printf("\nQue voulez-vous faire ? Liste : %d/2\n\
0 - quitter\n\
1 - insere un etudiant\n\
2 - effacer un etudiant\n\
3 - afficher la liste des etudiants\n\
4 - changer de liste\n\
5 - fusionner les listes et quitter\n", l+1);
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
      if (inserer(nom, numero, &tete)) {
	printf("\nErreur lors de l'insertion\n");
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
    case 4:
      /* on change de liste */
      l = !l;
      tete = listes[l];
      break;
    case 5:
      printf("FUSION...\n");
      tete = fusionner(listes[0], listes[1]);
      printf("\nNouvelle liste :\n");
      afficher(tete);
      /* on termine le programme */
      exit(0);
      break;
    default:
      printf("Action non reconnue.\n");
      break;
    }
  }



  return 0;
}
