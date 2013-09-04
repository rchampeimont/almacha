#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int testerPremier(unsigned long n) {
    unsigned long i;
    for (i=2; i<= sqrt((double) n); i++) {
        if (n%i == 0) {
            return 0;
        }
    }
    return 1;
}

unsigned long puissance(unsigned long x, unsigned long p) {
    unsigned long i;
    unsigned long r = 1;
    for (i=0; i<p; i++) {
        r *= x;
    }
    return r;
}

int estMersenne(unsigned long p) {
    return testerPremier(puissance(2, p) -1);
}

int main()
{
    unsigned long l;
    char s[100];
    while (l != 42) {
        printf("Entrez p dans 2^p - 1 :\n");
        fgets(s, sizeof(s), stdin);
        sscanf(s, "%lu", &l);
        printf("%lu %s un nombre de Mersenne.\n", puissance(2, l) -1, (estMersenne(l) ? "est" : "n'est pas"));
    }
	return 0;
}
