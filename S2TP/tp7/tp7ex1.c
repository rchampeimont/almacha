#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct et {
  char nom[20];
  int num;
  int suiv;
} et_t;

int chercher(const et_t * classe, int premier, int num) {
  while (premier >= 0) {
    if ((classe + premier)->num == num) {
      return premier;
    }
    premier = (classe + premier)->suiv;
  }
  return -1;
}

int inserer(et_t * classe, const char *nom, int num, int *premier) {
  int i;
  /* si le numero d'etudiant est nul on ne peut pas ajouter l'etudiant */
  if (!num) {
    return -1;
  }
  for (i = 0; i < 10; i++) {
    if ((classe + i)->num == 0) {
      /* on a trouve une case vide (ou num == 0) */
      (classe + i)->suiv = *premier;
      *premier = i;
      (classe + i)->num = num;
      strncpy((classe + i)->nom, nom, 20 - 1);
      *((classe + i)->nom + 20 - 1) = '\0';
      return i;
    }
  }
  /* pas de place dans le tableau -> echec (-1) */
  return -1;
}

int supprimer(et_t * classe, int *premier, int num) {
  int trouve;
  int suiv;
  int i;
  if (!num) {
    return -1;
  }
  trouve = chercher(classe, *premier, num);
  /* si non trouve */
  if (trouve < 0) {
    return -1;
  }
  /* si trouve */
  (classe + trouve)->num = 0;
  *((classe + trouve)->nom) = '\0';
  /* on met dans suiv le numero de la case suivante */
  suiv = (classe + trouve)->suiv;
  (classe + trouve)->suiv = -1;
  /* on met a suiv tous les (classe+i)->suiv qui valaient trouve */
  for (i = 0; i < 10; i++) {
    if ((classe + i)->suiv == trouve) {
      (classe + i)->suiv = suiv;
    }
  }
  return trouve;
}

/* affiche toute la liste en la parcourant */
void afficherL(const et_t * classe, int premier) {
  printf("Liste :\n");
  while (premier != -1) {
    printf("Nom: >%s< Num: %d Suiv: %d\n",
	   (classe + premier)->nom,
	   (classe + premier)->num,
	   (classe + premier)->suiv);
    /* aller a l'element suivant */
    premier = (classe + premier)->suiv;
  }
  printf("Fin de la liste\n");
}

/* affiche tout le tableau (utile pour debug) */
void afficherD(const et_t * classe) {
  int i;
  printf("Tableau :\n");
  for (i = 0; i < 10; i++) {
    printf("Nom: >%s< Num: %d Suiv: %d\n",
	   (classe + i)->nom,
	   (classe + i)->num,
	   (classe + i)->suiv);
  }
}


int main(void) {
  int premier = -1;
  et_t classe[10];
  int i;
  char nom[20];
  int num;
  int action;

  /* on initialise le tableau */
  for (i = 0; i < 10; i++) {
    *((classe + i)->nom) = '\0';
    (classe + i)->num = 0;
    (classe + i)->suiv = -1;
  }

  for (;;) {
    printf("\nQue voulez-vous faire ?\n\
0 - quitter\n\
1 - insere un etudiant\n\
2 - effacer un etudiant\n\
3 - afficher la liste des etudiants\n\
4 - afficher le contenu du tableau (pour le debug)\n");
    scanf("%d", &action);
    while (getchar() != '\n');
    printf("\n");
    switch (action) {
    case 0:
      exit(0);
      break;
    case 1:
      printf("Entrez le nom de l'etudiant :\n");
      scanf("%s", nom);
      printf("Entrez le numero de l'etudiant :\n");
      scanf("%d", &num);
      if (inserer(classe, nom, num, &premier) == -1) {
	printf("\nErreur lors de l'insertion\n");
      }
      break;
    case 2:
      printf("Entrez le numero de l'etudiant :\n");
      scanf("%d", &num);
      if (supprimer(classe, &premier, num) == -1) {
	printf("Erreur lors de la suppression.\n");
      }
      break;
    case 3:
      afficherL(classe, premier);
      break;
    case 4:
      afficherD(classe);
      break;
    default:
      printf("Action non reconnue.\n");
      break;
    }
  }


  return 0;
}
