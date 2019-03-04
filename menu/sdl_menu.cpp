#include <SDL.h>
#include <stdio.h>
#include <bcm_host.h>

int main(int argc, char* args[]) {

	SDL_Window* window = NULL;
	SDL_Renderer* renderer = NULL;
	//SDL_Texture* texture = NULL;

	//SDL_Rect rect;
	//rect.x = 0;
	//rect.y = 0;
	//rect.w = fullscreen.w;
	//rect.h = fullscreen.h;

	SDL_RendererInfo driver;
	SDL_DisplayMode fullscreen;

	//BCM host init
	bcm_host_init();

	if(SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER | SDL_INIT_EVENTS) != 0) return 1;

	if(SDL_GetRenderDriverInfo(0,&driver) != 0) printf("Failed to get driver info.");

	printf("Current driver: %s\n",driver.name);
	printf("      Software: %c\n",(driver.flags & SDL_RENDERER_SOFTWARE) ? 'x': ' ');
	printf("   Accelerated: %c\n",(driver.flags & SDL_RENDERER_ACCELERATED) ? 'x': ' ');
	printf("  Presentvsync: %c\n",(driver.flags & SDL_RENDERER_PRESENTVSYNC) ? 'x': ' ');
	printf(" Targettexture: %c\n",(driver.flags & SDL_RENDERER_TARGETTEXTURE) ? 'x': ' ');

	if(SDL_GetDesktopDisplayMode(0,&fullscreen) != 0) printf("Get resoultion failed.");

	window = SDL_CreateWindow("Menu", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 200, 200,
		SDL_WINDOW_HIDDEN | SDL_WINDOW_BORDERLESS | SDL_WINDOW_MAXIMIZED | SDL_WINDOW_FULLSCREEN_DESKTOP);
	//	SDL_WINDOW_SHOWN | SDL_WINDOW_BORDERLESS | SDL_WINDOW_MAXIMIZED | SDL_WINDOW_FULLSCREEN_DESKTOP);
	if(window == NULL) printf("Window init error.\n");

	renderer = SDL_CreateRenderer(window, 0, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_TARGETTEXTURE);
	if(renderer == NULL) printf("Renderer init error.\n");

	//texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_TARGET, fullscreen.w, fullscreen.h);
	//if(texture == NULL) printf("Texture init error.\n");

	printf("Resolution: %d x %d \n",fullscreen.w, fullscreen.h);

	//rect.x = 0;
	//rect.y = 0;
	//rect.w = fullscreen.w;
	//rect.h = fullscreen.h;

	SDL_ShowCursor(SDL_DISABLE);

	SDL_ShowWindow(window);
	SDL_RenderPresent(renderer);// Why?

	SDL_SetRenderDrawColor(renderer,0,0,0,255);
	SDL_RenderClear(renderer);
	//SDL_RenderCopy(renderer, texture, NULL, NULL);	
	SDL_RenderPresent(renderer);

	SDL_Delay(5000);
	//SDL_DestroyTexture(texture);
	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window);
	SDL_Quit();
	bcm_host_deinit();

	return 0;
}

