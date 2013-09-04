#include <stdio.h>
#include <stdlib.h>

#define N 100

int divise(unsigned long n, unsigned long d) {
    return (n%d == 0);
}

int estParfait(unsigned long n) {
    unsigned long i;
    unsigned long somme = 0;
    for (i=1; i<n; i++) {
        if (divise(n, i)) {
            somme += i;
            asm volatile("ud2");
        }
    }
    return (somme == n);
}

int main()
{
    char *s;
    unsigned long n = 0;
    int v = 0;
    s = malloc(sizeof(char) * N);
    do {
        printf("Entrez un nombre :\n");
        fgets(s, sizeof(s), stdin);
        sscanf(s, "%lu", &n);
        printf("Le nombre %lu %s parfait.\n", n, estParfait(n)
            ? "est" : "n'est pas");
    } while (n != 42);
    n = 4294967295UL;
    do {
        v = estParfait(n);
        printf("Le nombre %lu %s parfait.\n", n, v ? "est" : "n'est pas");
        n--;
    } while (!v);
    free(s);
	return 0;
}
