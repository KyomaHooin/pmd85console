//
// 1360x768 Sony TV
//

#include <SDL.h>
#include <SDL_ttf.h>
#include <stdio.h>
#include <bcm_host.h>

//--- DEF ---

const int SCREEN_HEIGHT = 256;
const int SCREEN_WIDTH = 288;

//--- MAIN ---

int main(int argc, char* args[]) {

	SDL_Window* window = NULL;
	SDL_Renderer* renderer = NULL;
	SDL_Texture* texture = NULL;
	SDL_RendererInfo driver;
	SDL_DisplayMode fullscreen;
	SDL_Rect screen_rect;

	bcm_host_init();// ?

	if(SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER | SDL_INIT_EVENTS) != 0) return 1;

	if(SDL_GetRenderDriverInfo(0,&driver) != 0) printf("Failed to get driver info.");
	printf("Current driver: %s\n",driver.name);
	printf("      Software: %c\n",(driver.flags & SDL_RENDERER_SOFTWARE) ? 'x': ' ');
	printf("   Accelerated: %c\n",(driver.flags & SDL_RENDERER_ACCELERATED) ? 'x': ' ');
	printf("  Presentvsync: %c\n",(driver.flags & SDL_RENDERER_PRESENTVSYNC) ? 'x': ' ');
	printf(" Targettexture: %c\n",(driver.flags & SDL_RENDERER_TARGETTEXTURE) ? 'x': ' ');
	if(SDL_GetDesktopDisplayMode(0,&fullscreen) != 0) printf("Get resoultion failed.");
	printf("    Resolution: %d x %d \n",fullscreen.w, fullscreen.h);

	screen_rect.w = SCREEN_WIDTH;
	screen_rect.h = SCREEN_HEIGHT;
	screen_rect.x = (fullscreen.w - screen_rect.w) / 2;
	screen_rect.h = (fullscreen.h - screen_rect.h) / 2;

	window = SDL_CreateWindow("Menu", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 200, 200, SDL_WINDOW_SHOWN | SDL_WINDOW_FULLSCREEN);
	if(window == NULL) printf("Window init error.\n");

	SDL_ShowCursor(SDL_DISABLE);

	renderer = SDL_CreateRenderer(window, 0, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_TARGETTEXTURE);
	if(renderer == NULL) printf("Renderer init error.\n");

	texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_ABGR8888, SDL_TEXTUREACCESS_STREAMING, screen_rect.w, screen_rect.h);
	if(texture == NULL) printf("Texture init error.\n");

	SDL_SetRenderDrawColor(renderer,0,0,0,255);
	SDL_RenderClear(renderer);// clrscr
	SDL_RenderPresent(renderer);

	SDL_RenderSetViewport(renderer,&screen_rect);
	SDL_ShowWindow(window);

	//loop()
	//
	// - get time
	// - update texture with random pixel data lock vs updatetexture
	// - update screen with texture
	// - sleep CPU_EMU_CYCLE

	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window);
	SDL_Quit();
	bcm_host_deinit();
	return 0;
}

