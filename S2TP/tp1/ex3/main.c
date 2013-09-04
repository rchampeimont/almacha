#include <stdio.h>

#define N 3

int T[N][N];

void construitCarre(void) {
    int i, j;
    for (i=0; i<N; i++) {
        for (j=0; j<N; j++) {
            printf("Entrez la valeur a la ligne %d colonne %d :", i, j);
            scanf("%d", &T[i][j]);
        }
    }
}

int test2(void) {
    int i, j;
    for (i=0; i<N; i++) {
        for (j=0; j<N; j++) {
            if (T[i][j] < 1 || T[i][j] > N*N) {
                return 0;
            }
        }
    }
    return 1;
}

int nombreDeVal(int val) {
    int n = 0;
    int i, j;
    for (i=0; i<N; i++) {
        for (j=0; j<N; j++) {
            if (T[i][j] == val) {
                n++;
            }
        }
    }
    return n;
}

int test3(void) {
    int i, j;
    for (i=0; i<N; i++) {
        for (j=0; j<N; j++) {
            if (nombreDeVal(T[i][j]) != 1 ) {
                return 0;
            }
        }
    }
    return 1;
}


int test4(void) {
    int i, j;
    int sommeLigne;
    /* somme premiere ligne */
    int somme1 = 0;
    for (j=0; j<N; j++) {
        somme1 += T[0][j];
    }
    printf("somme1 = %d\n", somme1);
    for (i=1; i<N; i++) {
        sommeLigne = 0;
        for (j=0; j<N; j++) {
            sommeLigne += T[i][j];
        }
        if (sommeLigne != somme1) {
            return 0;
        }
    }
    return 1;
}

int test5(void) {
    int i, j;
    int sommeColonne;
    /* somme premiere ligne */
    int somme1 = 0;
    for (i=0; i<N; i++) {
        somme1 += T[i][0];
    }
    for (j=1; j<N; j++) {
        sommeColonne = 0;
        for (i=0; i<N; i++) {
            sommeColonne += T[i][j];
        }
        if (sommeColonne != somme1) {
            return 0;
        }
    }
    return 1;
}

int estCarreMagique(void) {
    return (test2() && test3() && test4() && test5());
}

int main()
{
    int i, j;
    construitCarre();

    printf("\n");

    for (i=0; i<N; i++) {
        for (j=0; j<N; j++) {
            printf("%d ", T[i][j]);
        }
        printf("\n");
    }

    printf("\n");

    if (estCarreMagique()) {
        printf("C'est un carre magique.\n");
    } else {
        printf("Ce n'est pas un carre magique.\n");
    }

	return 0;
}
