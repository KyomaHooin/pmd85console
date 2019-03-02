#include <SDL.h>
#include <stdio.h>

const int MENU_SCREEN_WIDTH = 576;
const int MENU_SCREEN_HEIGHT = 532;
const int GAME_SLOT = 200;
const int GAME_SLOT_IMG= 174;

const char *gamefn[4] = {"flappy.bmp","boulder.bmp","manic.bmp","fred.bmp"};
const char *gametext[4] = {"Flappy","Boulder Dash","Manic Miner","Fred"};

void RenderGameMenu(SDL_Renderer *renderer, SDL_Rect border) {
	for (int i = 0; i < 4; i++) {
		char imgpath[40] = "/usr/local/share/gpmd85emu/";
		strcat(imgpath,gamefn[i]);
		//printf("Image: %s \n", imgpath);
		SDL_Rect slot_border, img_border;
		SDL_Surface *gameimg = SDL_LoadBMP(imgpath);
		SDL_Texture *imgtexture = SDL_CreateTextureFromSurface(renderer,gameimg);
		SDL_FreeSurface(gameimg);
		
		slot_border.w = GAME_SLOT;
		slot_border.h = GAME_SLOT;
		img_border.w = GAME_SLOT_IMG;
		img_border.h = GAME_SLOT_IMG;

		int slot_offset_x = (border.w - 2*GAME_SLOT) / 3;
		int slot_offset_y = (border.h - 2*GAME_SLOT) / 3;

		switch(i) {
			case 0:
				slot_border.x = border.x + slot_offset_x;
				slot_border.y = border.y + slot_offset_y;
			case 1:
				slot_border.x = border.x + 2*slot_offset_x + GAME_SLOT;
				slot_border.y = border.y + slot_offset_y;
			case 2:
				slot_border.x = border.x + slot_offset_x;
				slot_border.y = border.y + 2*slot_offset_y + GAME_SLOT;
			case 3:
				slot_border.x = border.x + 2*slot_offset_x + GAME_SLOT;
				slot_border.y = border.y + 2*slot_offset_y + GAME_SLOT;
		}
		img_border.x = slot_border.x + (GAME_SLOT - GAME_SLOT_IMG)/2;
		img_border.y = slot_border.y + (GAME_SLOT - GAME_SLOT_IMG)/2;
		
		SDL_RenderDrawRect(renderer,&slot_border);
		SDL_RenderCopy(renderer,imgtexture, NULL, &img_border);
	}
	return;
}

int main(int argc, char* args[]) {

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

			border.x = (fullscreen.w - MENU_SCREEN_WIDTH) / 2;
			border.y = (fullscreen.h - MENU_SCREEN_HEIGHT) / 2;
			border.w = MENU_SCREEN_WIDTH; 
			border.h = MENU_SCREEN_HEIGHT;

			SDL_SetRenderDrawColor(renderer,0,0,0,255);// black
			SDL_RenderClear(renderer);
			SDL_SetRenderDrawColor(renderer,255,255,255,255);// white
		
			SDL_RenderDrawRect(renderer,&border);
			RenderGameMenu(renderer,border);

			SDL_RenderPresent(renderer);
			SDL_Delay(10000);
			SDL_DestroyRenderer(renderer);
		}
		SDL_DestroyWindow(window);
	}	
	SDL_Quit();
	return 0;
}

