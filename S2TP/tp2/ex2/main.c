#include <stdio.h>
#include <stdlib.h>

float pied2m(float pied) {
    return pied*0.3048;
}

float m2cr(float m) {
    return m/0.525;
}

float pied2cr(float pied) {
    return m2cr(pied2m(pied));
}

int main()
{
    char s[100];
    float f;
    printf("Entrez un nombre de pieds : \n");
    fgets(s, sizeof(s), stdin);
    sscanf(s, "%f", &f);
	printf("%f pieds = %f coudees royales\n", f, pied2cr(f));
	return 0;
}
