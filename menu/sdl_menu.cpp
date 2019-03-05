#include <SDL.h>
#include <stdio.h>
#include <bcm_host.h>

const int MENU_WIDTH = 900;
const int MENU_HEIGHT = 300;
const int MENU_BORDER_WIDTH = 200;
const int MENU_BORDER_HEIGHT = 260;
const int MENU_SPACING = 20;
const int MENU_BORDER_W_OFFSET = (MENU_WIDTH -5 * MENU_SPACING - 4 * MENU_BORDER_WIDTH) / 2 ;
const int MENU_BORDER_H_OFFSET = (MENU_HEIGHT - 2 * MENU_SPACING - MENU_BORDER_HEIGHT) / 2 ;
const int MENU_IMAGE = 174;
const int MENU_IMAGE_OFFSET = (MENU_BORDER_WIDTH - MENU_IMAGE) / 2;
const int greyfade[4] = {0, 169, 221, 255};// dark to white
const char *gamefn[4] {
		"/usr/local/share/gpmd85emu/flappy.bmp",
		"/usr/local/share/gpmd85emu/boulder.bmp",
		"/usr/local/share/gpmd85emu/manic.bmp",
		"/usr/local/share/gpmd85emu/fred.bmp"
	};

int RenderMenuBorder(SDL_Renderer *renderer) {
	SDL_Rect border_rect;

	border_rect.w = MENU_BORDER_WIDTH;
	border_rect.h = MENU_BORDER_HEIGHT;

	SDL_SetRenderDrawColor(renderer, 169, 169, 169, 255);

	for (int i=0; i < 4; i++) {
		border_rect.x = MENU_BORDER_W_OFFSET + MENU_SPACING + i * (MENU_BORDER_WIDTH + MENU_SPACING)  ;
		border_rect.y = MENU_BORDER_H_OFFSET + MENU_SPACING;

		SDL_RenderDrawRect(renderer,&border_rect);
	}
	return 0;
}

int RenderMenuImage(SDL_Renderer *renderer) {
	SDL_Surface* bmp = NULL;
	SDL_Texture* image = NULL;
	SDL_Rect img_rect;

	img_rect.w = MENU_IMAGE;
	img_rect.h = MENU_IMAGE;

	image = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_STATIC, MENU_IMAGE, MENU_IMAGE);
	if(image == NULL) {
		printf("Image texture init error.\n");
		return 1;
	}

	for (int i=0; i < 4; i++) {
		bmp = SDL_LoadBMP(gamefn[i]);
		image = SDL_CreateTextureFromSurface(renderer, bmp);
		img_rect.x = MENU_BORDER_W_OFFSET + MENU_SPACING + MENU_IMAGE_OFFSET + i * (MENU_BORDER_WIDTH + MENU_SPACING);
		img_rect.y = MENU_BORDER_H_OFFSET + MENU_SPACING + MENU_IMAGE_OFFSET;

		SDL_RenderCopy(renderer, image, NULL, &img_rect);
	}

	SDL_FreeSurface(bmp);
	SDL_DestroyTexture(image);
	return 0;
}

int main(int argc, char* args[]) {

	SDL_Window* window = NULL;
	SDL_Renderer* renderer = NULL;
	SDL_Event e;

	SDL_RendererInfo driver;
	SDL_DisplayMode fullscreen;

	bcm_host_init();// ?

	if(SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER | SDL_INIT_EVENTS) != 0) return 1;

	if(SDL_GetRenderDriverInfo(0,&driver) != 0) printf("Failed to get driver info.");

	printf("Current driver: %s\n",driver.name);
	printf("      Software: %c\n",(driver.flags & SDL_RENDERER_SOFTWARE) ? 'x': ' ');
	printf("   Accelerated: %c\n",(driver.flags & SDL_RENDERER_ACCELERATED) ? 'x': ' ');
	printf("  Presentvsync: %c\n",(driver.flags & SDL_RENDERER_PRESENTVSYNC) ? 'x': ' ');
	printf(" Targettexture: %c\n",(driver.flags & SDL_RENDERER_TARGETTEXTURE) ? 'x': ' ');

	if(SDL_GetDesktopDisplayMode(0,&fullscreen) != 0) printf("Get resoultion failed.");

	window = SDL_CreateWindow("Menu", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 200, 200, SDL_WINDOW_SHOWN | SDL_WINDOW_FULLSCREEN);
	if(window == NULL) printf("Window init error.\n");

	SDL_ShowCursor(SDL_DISABLE);

	renderer = SDL_CreateRenderer(window, 0, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_TARGETTEXTURE);
	if(renderer == NULL) printf("Renderer init error.\n");

	printf("Resolution: %d x %d \n",fullscreen.w, fullscreen.h);

	SDL_ShowWindow(window);
	SDL_RenderPresent(renderer);// ?

	SDL_SetRenderDrawColor(renderer,0,0,0,255);
	SDL_RenderClear(renderer);// clrscr	

	//default
	RenderMenuImage(renderer);
	RenderMenuBorder(renderer);

	//event loop code..

	SDL_RenderPresent(renderer);

	SDL_Delay(10000);
	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window);
	SDL_Quit();
	bcm_host_deinit();

	return 0;
}

