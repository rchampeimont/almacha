#include <stdio.h>
#include <stdlib.h>

typedef struct s_enf {
	char nom;
	struct s_enf *suiv;
} enf;

typedef struct s_ronde {
	int n;
	int ferme;
	enf *drapeau;
	enf *premier;
	enf *dernier;
} ronde;

void afficher(ronde *r) {
	enf *i;
	int j;

	printf("Enfants : ");

	if (r->ferme) {
		i = r->drapeau;
		printf("Enfants : ");
		for (j=0; j < r->n; j++) {
			printf("%c ", i->nom);
			i = i->suiv;
		}
	} else {
		i = r->premier;
		while (i) {
			printf("%c ", i->nom);
			i = i->suiv;
		}	
	}

	printf("\n");
}

void creerRonde(ronde *r, char nom) {
	enf *e;

	e = malloc(sizeof(enf));
	e->nom = nom;
	e->suiv = NULL;
	r->n = 1;
	r->ferme = 0;
	r->drapeau = e;
	r->premier = e;
	r->dernier = e;
}

void ajouterADroite(ronde *r, char nom) {
	enf *e;

	e = malloc(sizeof(enf));
	e->nom = nom;
	e->suiv = NULL;
	r->dernier->suiv = e;
	r->dernier = e;
	r->n++;
}

void ajouterAGauche(ronde *r, char nom) {
	enf *e;

	e = malloc(sizeof(enf));
	e->nom = nom;
	e->suiv = r->premier;
	r->premier = e;
	r->n++;
}

void supprimer(ronde *r) {
	/* enfant a supprimer */
	enf *as;
	as = r->drapeau->suiv;
	r->drapeau->suiv = as->suiv;
	r->drapeau = as->suiv;
	r->n--;
	free(as);
}

void fermer(ronde *r) {
	r->ferme = 1;
	r->dernier->suiv = r->premier;
}
	

int main(void) {
	ronde r;
	int action;
	creerRonde(&r, 'A');
	afficher(&r);
	for (;;) {
		printf("\n\n");
		afficher(&r);
		printf("\n\nQue voulez-vous faire ?\n\
q - Quitter\n\
d - ajouter un enfant a droite\n\
g - ajouter un enfant a gauche\n\
f - fermer\n\
s - supprimer un enfant\n\
\n");
		action = getchar();
		while (getchar() != '\n');
		printf("\n");
		switch (action) {
		case 'q':
			exit(0);
			break;
		case 'd':
			printf("Nom : ");
			ajouterADroite(&r, getchar());
			while (getchar() != '\n');
			break;
		case 'g':
			printf("Nom : ");
			ajouterAGauche(&r, getchar());
			while (getchar() != '\n');
			break;
		case 's':
			supprimer(&r);
			break;
		case 'f':
			fermer(&r);
			break;
		default:
			break;
		}
	}	


	return 0;
}
