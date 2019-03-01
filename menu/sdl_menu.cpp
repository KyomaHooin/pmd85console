#include <SDL.h>
#include <stdio.h>

const int MENU_SCREEN_WIDTH = 576;
const int MENU_SCREEN_HEIGHT = 512 + 20;

int main( int argc, char* args[] ) {

SDL_Window* window = NULL;
SDL_Surface* surface = NULL;

	if( SDL_Init(SDL_INIT_VIDEO) < 0) {
		printf("Video init error.");
	}	

	SDL_Quit();

}
