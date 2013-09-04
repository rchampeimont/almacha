#include <stdio.h>

/* cette fonction permet la saisie d'une matrice m */
void saisie(int m[3][3]) {
  int i, j;
  for (i=0; i<3; i++) {
    for (j=0; j<3; j++) {
      printf("Entrez la valeur de la ligne %d colonne %d :\n", i, j);
      scanf("%d", &m[i][j]);
    }
  }
}

/* affiche la matrice m */
void affiche(int m[3][3]) {
  int i, j;
  for (i=0; i<3; i++) {
    for (j=0; j<3; j++) {
      printf("%5d", m[i][j]);
    }
    printf("\n");
  }
}

/* retourne le determinant de m */
int determinant(int m[3][3]) {
  int det = 0;
  int j;
  for (j=0; j<3; j++) {
    det += m[0][j] * m[1][(j+1)%3] * m[2][(j+2)%3];
  }
  for (j=2; j>=0; j--) {
    det -= m[0][j] * m[1][(3+j-1)%3] * m[2][(3+j-2)%3];
  }
  return det;
}

/* retourne si la matrice m est inversible */
int estInversible(int m[3][3]) {
  if (determinant(m)) {
    return 0;
  } else {
    return 1;
  }
}

/* transpose la matrice m */
void transpose(int m[3][3]) {
  int tmp[3][3];
  int i, j;
  for (i=0; i<3; i++) {
    for (j=0; j<3; j++) {
      tmp[i][j] = m[j][i];
    }
  }
  /* on recopie tmp dans m */
  for (i=0; i<3; i++) {
    for (j=0; j<3; j++) {
      m[i][j] = tmp[i][j];
    }
  }
}

int main() {
  int m[3][3];
  saisie(m);
  printf("\nLa matrice :\n");
  affiche(m);
  printf("\nDeterminant : %d\n", determinant(m));
  printf("La matrice %s inversible.\n",
	 !estInversible(m) ? "est" : "n'est pas");
  transpose(m);
  printf("\nLa matrice transposee :\n");
  affiche(m);



  return 0;
}
