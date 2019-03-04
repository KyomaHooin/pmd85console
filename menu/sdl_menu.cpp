#include <SDL.h>
#include <stdio.h>

int main(int argc, char* args[]) {

	SDL_Window* window = NULL;
	SDL_Renderer* renderer = NULL;
	SDL_Texture* texture = NULL;
	SDL_Rect* screen = NULL;

	SDL_RendererInfo driver;
	SDL_DisplayMode fullscreen;


	if(SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER | SDL_INIT_EVENTS) != 0) return 1;

	if(SDL_GetRenderDriverInfo(0,&driver) != 0) printf("Failed to get driver info.");

	//printf("Drivers: %i\n\n",SDL_GetNumRenderDrivers());
	printf("Current driver: %s\n",driver.name);
	printf("      Software: %c\n",(driver.flags & SDL_RENDERER_SOFTWARE) ? 'x': ' ');
	printf("   Accelerated: %c\n",(driver.flags & SDL_RENDERER_ACCELERATED) ? 'x': ' ');
	printf("  Presentvsync: %c\n",(driver.flags & SDL_RENDERER_PRESENTVSYNC) ? 'x': ' ');
	printf(" Targettexture: %c\n",(driver.flags & SDL_RENDERER_TARGETTEXTURE) ? 'x': ' ');

	if(SDL_GetDesktopDisplayMode(0,&fullscreen) != 0) printf("Get resoultion failed.");

	window = SDL_CreateWindow("Menu",SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 200, 200, 0);

	if(window == NULL) printf("Window init error.\n");

	renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

	if(renderer == NULL) printf("Renderer init error.\n");

	texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888,SDL_TEXTUREACCESS_STATIC, fullscreen.w, fullscreen.h);

	if(texture == NULL) printf("Texture init error.\n");

	printf("Resolution: %d x %d \n",fullscreen.w, fullscreen.h);

	//screen.h = fullscreen.h / 2;
	//screen.w = fullscreen.w / 2;
	//screen.x = 0;
	//screen.y = 0;

	SDL_ShowCursor(SDL_DISABLE);
	SDL_Delay(100);

	SDL_SetRenderDrawColor(renderer,255,255,255,255);
	SDL_RenderClear(renderer);
	SDL_RenderCopy(renderer, texture, NULL, NULL);
	SDL_RenderPresent(renderer);

	SDL_Delay(5000);
	SDL_DestroyTexture(texture);
	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window);
	SDL_Quit();

	return 0;
}

