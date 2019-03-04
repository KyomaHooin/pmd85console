#include <SDL.h>
#include <stdio.h>
#include <bcm_host.h>

int main(int argc, char* args[]) {

	SDL_Window* window = NULL;
	SDL_Renderer* renderer = NULL;
	SDL_Surface* bmp = NULL;
	SDL_Texture* image = NULL;
	SDL_Texture* menu = NULL;

	SDL_Rect img_rect;
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

	window = SDL_CreateWindow("Menu", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 200, 200,
		SDL_WINDOW_HIDDEN | SDL_WINDOW_BORDERLESS | SDL_WINDOW_MAXIMIZED | SDL_WINDOW_FULLSCREEN_DESKTOP);
	//	SDL_WINDOW_SHOWN | SDL_WINDOW_BORDERLESS | SDL_WINDOW_MAXIMIZED | SDL_WINDOW_FULLSCREEN_DESKTOP);
	if(window == NULL) printf("Window init error.\n");

	renderer = SDL_CreateRenderer(window, 0, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_TARGETTEXTURE);
	if(renderer == NULL) printf("Renderer init error.\n");

	image = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_STATIC, fullscreen.w, fullscreen.h);
	if(image == NULL) printf("Texture init error.\n");

	menu = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_STREAMING, fullscreen.w, fullscreen.h);
	if(menu == NULL) printf("Texture init error.\n");

	printf("Resolution: %d x %d \n",fullscreen.w, fullscreen.h);

	SDL_ShowCursor(SDL_DISABLE);

	img_rect.x = (fullscreen.w - 174) / 2;
	img_rect.y = (fullscreen.h - 174) / 2;
	img_rect.h = 174;
	img_rect.w = 174;

	bmp = SDL_LoadBMP("/usr/local/share/gpmd85emu/flappy.bmp");
	image = SDL_CreateTextureFromSurface(renderer, bmp);
	SDL_FreeSurface(bmp);

	SDL_ShowWindow(window);
	SDL_RenderPresent(renderer);// ?

	SDL_SetRenderDrawColor(renderer,0,0,0,255);
	SDL_RenderClear(renderer);// slrscr	

	SDL_SetRenderTarget(renderer,menu);// set target texture
	SDL_RenderCopy(renderer, image, NULL, &img_rect);// copy image to targer
	//SDL_RenderPresent(renderer);

	SDL_Delay(5000);
	SDL_DestroyTexture(image);
	SDL_DestroyTexture(menu);
	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window);
	SDL_Quit();
	bcm_host_deinit();

	return 0;
}

