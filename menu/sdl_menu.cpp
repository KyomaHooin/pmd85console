#include <SDL.h>
#include <stdio.h>

const int MENU_SCREEN_WIDTH = 576;
const int MENU_SCREEN_HEIGHT = 532;

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

void DrawGameRect() {
//	for 'pic,text, pos' ' in dict' do
//		draw rect
//		draw pic
//		draw text
	return;
}

void DrawBorder(int pos, bool hightlight = true) {
//	if hightligh set border_high else set border_default
//	redraw_border(pos)
	return;
}

