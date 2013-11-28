/////////////////////////////////////////////////////////////////////
/*
* Ce fichier donne un exemple pour créer un jeu
* avec deux serpents. Le premier qui touche l'autre serpent
* ou lui-même a perdu.
* Les serpents sont contrôlés par les flèches et les touches IJKL.
* Ecrit par Raphael Champeimont.
*/
/////////////////////////////////////////////////////////////////////

#include <cini.h>
#include <cini_graphic.h>

// ajout necessaire pour le bon fonctionnement de my_key_down()
#include <SDL/SDL.h>
SDL_Surface *CINI_get_screen(void);

// Taile en pixels d'une case pour l'affichage
#define SIZE 5
// Hauteur et largeur de la zone de jeu en nombre de cases
#define WIDTH 160
#define HEIGHT 120

int M[WIDTH][HEIGHT];

/*
 * Cette fonction renvoie le numéro de la touche appuyée par le joueur
 * et -1 si l'utilisateur n'a pas appuyé sur une touche ou si la fenêtre s'est fermée
 * Fonction adaptée à partir de CINI_key_down() et CINI_loop_until_keydown()
 */
int my_key_down() {
  SDL_Event event;
  SDL_Surface *screen;

  // Redraw backbuffer.
  screen = CINI_get_screen();
  SDL_Flip(screen);

  // Poll system for an event.
  while(SDL_PollEvent(&event))
  {
    switch(event.type)
    {
      // If the window has been closed, then stop the loop.
    case SDL_QUIT:
      return -1;

      // A key has been pressed.
    case SDL_KEYDOWN:
      return event.key.keysym.sym;
    }
  }
  return -1;
}



void clearMatrix() {
  int x, y;
  for (x=0; x<WIDTH; x++) {
    for (y=0; y<HEIGHT; y++) {
      M[x][y] = 0;
    }
  }
}

void drawMatrix() {
  int x, y;
  for (x=0; x<WIDTH; x++) {
    for (y=0; y<HEIGHT; y++) {
      if (M[x][y] == 1) {
        CINI_fill_rect(x*SIZE, y*SIZE, SIZE, SIZE, "red");
      } else if (M[x][y] == 2) {
        CINI_fill_rect(x*SIZE, y*SIZE, SIZE, SIZE, "green");
      } else {
        CINI_fill_rect(x*SIZE, y*SIZE, SIZE, SIZE, "white");
      }
    }
  }
}

int main() {
  int winWidth = SIZE*WIDTH;
  int winHeight = SIZE*HEIGHT;
  CINI_open_window(winWidth, winHeight, "Serpents");
  int k, x, y, dx, dy, x2, y2, dx2, dy2;
  bool continuer;
  bool attendre;

  while (true) {
    // Nouvelle partie
    clearMatrix();
    x = 10;
    y = 10;
    dx = 1;
    dy = 0;
    x2 = 50;
    y2 = 50;
    dx2 = 1;
    dy2 = 0;

    continuer = true;
    while (continuer) {
      k = my_key_down();
      if (k != -1) {
        printf("Appui sur la touche %d\n", k);
        switch (k) {
        case 27:
          return 0;
          break;

          // SNAKE 1
        case 275:
          if (dx == 0) {
            dx = 1;
            dy = 0;
          }
          break;
        case 274:
          if (dy == 0) {
            dx = 0;
            dy = 1;
          }
          break;
        case 276:
          if (dx == 0) {
            dx = -1;
            dy = 0;
          }
          break;
        case 273:
          if (dy == 0) {
            dx = 0;
            dy = -1;
          }
          break;


          // SNAKE 2
        case 108:
          if (dx2 == 0) {
            dx2 = 1;
            dy2 = 0;
          }
          break;
        case 107:
          if (dy2 == 0) {
            dx2 = 0;
            dy2 = 1;
          }
          break;
        case 106:
          if (dx2 == 0) {
            dx2 = -1;
            dy2 = 0;
          }
          break;
        case 105:
          if (dy2 == 0) {
            dx2 = 0;
            dy2 = -1;
          }
          break;
        }
      }
      if (continuer) {
        // Attendre n milisecondes
        SDL_Delay(20);

        x = x + dx;
        if (x < 0) x = WIDTH-1;
        if (x == WIDTH) x = 0;
        y = y + dy;
        if (y < 0) y = HEIGHT-1;
        if (y == HEIGHT) y = 0;

        x2 = x2 + dx2;
        if (x2 < 0) x2 = WIDTH-1;
        if (x2 == WIDTH) x2 = 0;
        y2 = y2 + dy2;
        if (y2 < 0) y2 = HEIGHT-1;
        if (y2 == HEIGHT) y2 = 0;
      }

      if ((M[x][y] != 0 && M[x2][y2] != 0) || (x == x2 && y == y2)) {
        CINI_draw_string(winWidth/2, winHeight/2, "black", "Ex aequo.");
        continuer = false;
      }

      if (continuer) {
        if (M[x][y] != 0) {
          CINI_draw_string(winWidth/2, winHeight/2, "green", "Vert gagne.");
          continuer = false;
        }
        if (M[x2][y2] != 0) {
          CINI_draw_string(winWidth/2, winHeight/2, "red", "Rouge gagne.");
          continuer = false;
        }

        if (continuer) {
          M[x][y] = 1;
          M[x2][y2] = 2;
          drawMatrix(M);
        } else {
          CINI_draw_string(100, 10, "black", "Appuyez sur ENTREE pour rejouer.");
          CINI_draw_string(100, 40, "black", "Appuyez sur ECHAP pour quitter.");
        }
      }
    }

    // Fin de partie
    attendre = true;
    while (attendre) {
      k = my_key_down();
      // 27 = touche echap
      if (k == 27) return 0;
      // 13 = touche entree = pour rejouer
      if (k == 13) attendre = false;
    }

  }

  return 0;
}
