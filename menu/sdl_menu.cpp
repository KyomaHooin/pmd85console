#include <SDL.h>
#include <stdio.h>
#include <string.h>

const int MENU_SCREEN_WIDTH = 576;
const int MENU_SCREEN_HEIGHT = 532;
const int GAME_SLOT_WIDTH = 286;
const int GAME_SLOT_HEIGHT = 130;
const int GAME_SLOT_OFFSET = 3;

const char *gamefn[4] = {"flappy","boulder","manic","fred"};
const char *gametext[4] = {"Flappy","Boulder Dash","Manic Miner","Fred"};

SDL_Rect DrawBorder(int pos, bool hightlight = true) {
	SDL_Rect border; 
//	if hightligh set border_high else set border_default
//	redraw_border(pos)
	return border;
}


void DrawGameRect() {
	for (int i = 0; i < 4; i++) {
		printf("Image: %s \n", gamefn[i]);
		//create border
		//create surface
		//load image
		//..
		//destroy surface
	}
//		draw rect
//		draw pic
//		draw text
	return;
}

int main(int argc, char* args[]) {

	DrawGameRect();
	return 0 ;

	SDL_Window* window = NULL;
	SDL_Renderer* renderer = NULL;
	SDL_Rect border;
	SDL_DisplayMode fullscreen;

	if(SDL_Init(SDL_INIT_VIDEO) < 0) {
		printf("Video init error.\n");
	}
	printf("Video init ok.\n");

	if(SDL_GetDesktopDisplayMode(0,&fullscreen) != 0) { printf("Get resoultion failed.");
	} else {
		printf("Resolution %d x %d \n",fullscreen.w, fullscreen.h);
	}

	window = SDL_CreateWindow("Menu",SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
		       	MENU_SCREEN_WIDTH, MENU_SCREEN_HEIGHT, SDL_WINDOW_SHOWN | SDL_WINDOW_FULLSCREEN_DESKTOP);
	if(window == NULL) {
		printf("Window init error.\n");
	} else {
		printf("Window init ok.\n");
	
		renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
		if(renderer == NULL) {
			printf("Renderer init error.\n");
		} else {
			printf("Renderer init ok.\n");

			SDL_ShowCursor(SDL_DISABLE);

			border.x = (fullscreen.h - MENU_SCREEN_HEIGHT) / 2;
			border.y = (fullscreen.w - MENU_SCREEN_WIDTH) / 2;
			border.w = MENU_SCREEN_WIDTH; 
			border.h = MENU_SCREEN_HEIGHT;

			SDL_SetRenderDrawColor(renderer,0,0,0,255); //black
			SDL_RenderClear(renderer);
			SDL_SetRenderDrawColor(renderer,255,255,255,255); //white
			SDL_RenderDrawRect(renderer,&border);
			SDL_RenderPresent(renderer);

			SDL_Delay(5000);
			SDL_DestroyRenderer(renderer);
		}
		SDL_DestroyWindow(window);
	}	
	SDL_Quit();
	return 0;
}

