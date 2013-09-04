#include <stdio.h>
#include <stdlib.h>
#include "SDL.h"

int main(void) {
	SDL_Surface* screen = NULL;
	SDL_Event event;
	SDL_Surface* black = NULL;
	SDL_Surface* white = NULL;
	SDL_Surface* tmp = NULL;

	SDL_Init(SDL_INIT_VIDEO);
	atexit(SDL_Quit);
	screen = SDL_SetVideoMode(640, 480, 32, SDL_FULLSCREEN | SDL_DOUBLEBUF | SDL_HWSURFACE);
	white = SDL_CreateRGBSurface(SDL_HWSURFACE, 640, 480, 32, screen->format->Rmask, screen->format->Gmask, screen->format->Bmask, screen->format->Amask);
	black = SDL_CreateRGBSurface(SDL_HWSURFACE, 800, 480, 32, screen->format->Rmask, screen->format->Gmask, screen->format->Bmask, screen->format->Amask);
	SDL_FillRect(white, NULL, 0xffffff);
	SDL_FillRect(black, NULL, 0);
	white = SDL_DisplayFormat(tmp = white);
	SDL_FreeSurface(tmp); tmp = NULL;
	black = SDL_DisplayFormat(tmp = black);
	SDL_FreeSurface(tmp); tmp = NULL;
	
	while (1) {
		while (SDL_PollEvent(&event)) {
			switch (event.type) {
			case SDL_KEYDOWN:
			case SDL_QUIT:
				exit(0);
				break;
			default:
				break;
			}
		}
		SDL_BlitSurface(white, NULL, screen, NULL);
		SDL_Flip(screen);
		SDL_Delay(25);
		SDL_BlitSurface(black, NULL, screen, NULL);
		SDL_Flip(screen);
		SDL_Delay(100);
	}

	return 0;
}
