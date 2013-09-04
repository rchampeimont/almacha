#include <stdio.h>
#include <stdlib.h>

char s[10];

int racine_naive(int y) {
    int x = 0;
    if (y < 0) {
        printf("Erreur : %d est negatif.\n", y);
        exit(1);
    }
    while (x*x <= y) {
        x++;
    }
    return x-1;
}

int racine_methimp(int y) {
    int i=1, s=1;
    if (y < 0) {
        printf("Erreur : %d est negatif.\n", y);
        exit(1);
    }
    while (s <= y) {
        s += 2*i+1;
        i++;
    }
    return i-1;
}

int main() {
    int n;
    printf("Saissez un nombre : \n");
    fgets(s, sizeof(s), stdin);
    sscanf(s, "%d", &n);
	printf("La racine carre est (methode naive) : %d\n", racine_naive(n));
	printf("La racine carre est (methode 2) : %d\n", racine_methimp(n));
	return 0;
}
