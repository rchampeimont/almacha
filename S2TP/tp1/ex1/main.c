#include <stdio.h>

#define NOTES 10

int main()
{
    float t[NOTES];
    int i;
    float moy = 0;
    float min = 20;
    float max = 0;

    for (i=0; i<NOTES; i++) {
        printf("Saisissez une note : \n");
        scanf("%f", t+i);
    }

    for (i=0; i<NOTES; i++) {
        if (*(t+i) < min) {
            min = *(t+i);
        }
    }

    for (i=0; i<NOTES; i++) {
        if (*(t+i) > max) {
            max = *(t+i);
        }
    }

    for (i=0; i<NOTES; i++) {
        moy += *(t+i);
    }

    moy -= min + max;
    moy /= NOTES-2;
    printf("Moyenne sans les 2 notes extremes (%f et %f) : %f\n", min, max, moy);



 	return 0;
}
