#include <stdio.h>
#include <stdlib.h>

char t[100];

void mot2tab(char *s) {
    int i;
    int c;
    printf("Entrez un mot :\n");
    for (i=0;; i++) {
        c = getchar();
        if (c != '.') {
            *(s+i) = c;
        } else {
            *(s+i) = '\0';
            break;
        }
    }
}

int taille(const char *s) {
    int i;
    for (i=0;; i++) {
        if (*(s+i) == '\0') {
            return i;
        }
    }
}

int palindrome(const char *s) {
    int i;
    int l = taille(s);
    for (i=0; i<l/2; i++) {
        if (*(s+i) != *(s+l-1-i)) {
            return 0;
        }
    }
    return 1;
}

int main()
{
	mot2tab(t);
	if (palindrome(t)) {
        printf("Le mot est un palindrome.\n");
	} else {
	    printf("Le mot n'est pas un palindrome.\n");
	}
	return 0;
}
