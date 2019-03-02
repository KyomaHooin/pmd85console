#include <SDL.h>
#include <stdio.h>
#include <string.h>

const int MENU_SCREEN_WIDTH = 576;
const int MENU_SCREEN_HEIGHT = 532;
const int MENU_TEXT_OFFSET = 20;

//const int GAME_SLOT_WIDTH = 286;
//const int GAME_SLOT_HEIGHT = 130;
const int GAME_SLOT_OFFSET = 3;
const int GAME_SLOT_IMG_OFFSET = 3;
const int GAME_SLOT_IMG_SIZE = 174;

const char *gamefn[4] = {"flappy.bmp","boulder.bmp","manic.bmp","fred.bmp"};
const char *gametext[4] = {"Flappy","Boulder Dash","Manic Miner","Fred"};

void DrawGameRect(SDL_Renderer *renderer, SDL_Rect border) {

	for (int i = 0; i < 4; i++) {
		char imgpath[40] = "/usr/local/share/gpmd85emu/";
		strcat(imgpath,gamefn[i]);

		//	printf("Image: %s \n", imgpath);
		SDL_Rect slot_rect, img_rect;
		SDL_Surface *gameimg = SDL_LoadBMP(imgpath);
		SDL_Texture *imgtexture = SDL_CreateTextureFromSurface(renderer,gameimg);
		SDL_FreeSurface(gameimg);

		slot_rect.w = (MENU_SCREEN_WIDTH - 4*GAME_SLOT_OFFSET) / 2;
		slot_rect.h = (MENU_SCREEN_HEIGHT - 4*GAME_SLOT_OFFSET) / 2;
		img_rect.w = GAME_SLOT_IMG_SIZE;
		img_rect.h = GAME_SLOT_IMG_SIZE;

		switch(i) {
			case 0:
				slot_rect.x = border.w + GAME_SLOT_OFFSET;
				slot_rect.y = border.h + GAME_SLOT_OFFSET;
				img_rect.x = slot_rect.x + GAME_SLOT_IMG_OFFSET;
				img_rect.y = slot_rect.y + (slot_rect.h - img_rect.w) / 2;
			case 1:
				slot_rect.x = border.w + slot_rect.w + 3*GAME_SLOT_OFFSET;
				slot_rect.y = border.h + GAME_SLOT_OFFSET;
				img_rect.x = slot_rect.x + GAME_SLOT_IMG_OFFSET;
				img_rect.y = slot_rect.y + (slot_rect.h - img_rect.w) / 2;
			case 2:
				slot_rect.x = border.w + GAME_SLOT_OFFSET;
				slot_rect.y = border.h + slot_rect.h + 3*GAME_SLOT_OFFSET;
				img_rect.x = slot_rect.x + GAME_SLOT_IMG_OFFSET;
				img_rect.y = slot_rect.y + (slot_rect.h - img_rect.w) / 2;
			case 3:
				slot_rect.x = border.w + slot_rect.w + 3*GAME_SLOT_OFFSET;
				slot_rect.y = border.h + slot_rect.h + 3*GAME_SLOT_OFFSET;
				img_rect.x = slot_rect.x + GAME_SLOT_IMG_OFFSET;
				img_rect.y = slot_rect.y + (slot_rect.h - img_rect.w) / 2;
		}
		SDL_RenderDrawRect(renderer,&slot_rect);// slot border
		SDL_RenderCopy(renderer,imgtexture, NULL, &img_rect); // game img texture
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
		
			SDL_RenderDrawRect(renderer,&border);// menu border
			DrawGameRect(renderer,border); // slot border + game BMP image

			SDL_RenderPresent(renderer);
			SDL_Delay(5000);
			SDL_DestroyRenderer(renderer);
		}
		SDL_DestroyWindow(window);
	}	
	SDL_Quit();
	return 0;
}

