#include <stdio.h>

/* convertit H heures et M minutes en minutes */
int convert_hm_m(int H, int M) {
  return 60*H + M;
}

/* convertit minutes en H et M */
void convert_m_hm(int *H, int *M, int minutes) {
  *H = minutes/60;
  *M = minutes%60;
}

/* cacule l'heure de fin en utilisant
   l'heure de debut et la duree d'un film */
void calcule_horaire_fin(int debutH, int debutM,
			 int dureeH, int dureeM,
			 int *finH, int *finM) {
  int debut, duree, fin;
  debut = convert_hm_m(debutH, debutM);
  duree = convert_hm_m(dureeH, dureeM);
  fin = debut + duree;
  convert_m_hm(finH, finM, fin);
  /* cas ou on a obtenu un resultat comme 24h45 (finH >= 24) */
  *finH %= 24;
}

int main() {
  int debutH, debutM, dureeH, dureeM, finH, finM;
  printf("Heure de debut du film, heures (2 chiffres max) :\n");
  scanf("%d", &debutH);
  printf("Heure de debut du film, minutes (2 chiffres max) :\n");
  scanf("%d", &debutM);
  printf("Duree du film, heures (2 chiffres max) :\n");
  scanf("%d", &dureeH);
  printf("Duree du film, minutes (2 chiffres max) :\n");
  scanf("%d", &dureeM);
  calcule_horaire_fin(debutH, debutM, dureeH, dureeM, &finH, &finM);
  printf("Debut : %02d:%02d\nDuree : %02d:%02d\nFin   : %02d:%02d\n", debutH, debutM, dureeH, dureeM, finH, finM);
  return 0;
}
