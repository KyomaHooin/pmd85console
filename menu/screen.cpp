//
// 1360x768 Sony TV
//

#include <SDL.h>
#include <SDL_ttf.h>
#include <SDL_thread.h>
#include <stdio.h>
#include <bcm_host.h>

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
	// BCM
	bcm_host_init();
	// SDL INIT
	if(SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER | SDL_INIT_EVENTS) != 0) return 1;
	// SDL INFO
	if(SDL_GetRenderDriverInfo(0,&driver) != 0) printf("Failed to get driver info.");
	printf("Current driver: %s\n",driver.name);
	printf("      Software: %c\n",(driver.flags & SDL_RENDERER_SOFTWARE) ? 'x': ' ');
	printf("   Accelerated: %c\n",(driver.flags & SDL_RENDERER_ACCELERATED) ? 'x': ' ');
	printf("  Presentvsync: %c\n",(driver.flags & SDL_RENDERER_PRESENTVSYNC) ? 'x': ' ');
	printf(" Targettexture: %c\n",(driver.flags & SDL_RENDERER_TARGETTEXTURE) ? 'x': ' ');
	if(SDL_GetDesktopDisplayMode(0,&fullscreen) != 0) printf("Get resoultion failed.");
	printf("    Resolution: %d x %d \n",fullscreen.w, fullscreen.h);
	if (SDL_BYTEORDER == SDL_BIG_ENDIAN) printf("    Big endian.\n");
	if (SDL_BYTEORDER == SDL_LIL_ENDIAN) printf("    Little endian.\n");
	// SCREEN
	screen_rect.w = SCREEN_WIDTH;
	screen_rect.h = SCREEN_HEIGHT;
	screen_rect.x = (fullscreen.w - screen_rect.w) / 2;
	screen_rect.y = (fullscreen.h - screen_rect.h) / 2;
	printf("      Viewport: %d x %d \n",screen_rect.w, screen_rect.h);
	printf("        Offset: %d x %d \n",screen_rect.x, screen_rect.y);
	// WINDOW
	window = SDL_CreateWindow("Menu", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 200, 200, SDL_WINDOW_SHOWN | SDL_WINDOW_FULLSCREEN);
	if(window == NULL) printf("Window init error.\n");
	// TUNE
	SDL_ShowCursor(SDL_DISABLE);
	SDL_SetHint(SDL_HINT_RENDER_VSYNC, 0);// disable VSYNC
	SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, 0);//disable scaling
	// RENDERER
	renderer = SDL_CreateRenderer(window, 0, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_TARGETTEXTURE);
	if(renderer == NULL) printf("Renderer init error.\n");
	// TEXTURE
	texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_STREAMING, screen_rect.w, screen_rect.h);
	if(texture == NULL) printf("Texture init error.\n");


	// BEGIN -----------------------------

	SDL_ShowWindow(window);

	//CLRSCR
	SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);// set black
	SDL_RenderClear(renderer);
	SDL_RenderSetViewport(renderer, &screen_rect);// set viewport

	Uint32 start = SDL_GetTicks();

	int w, h, pitch;
	void* pixels;
	
	Uint32 *upixels = (Uint32*) pixels;
	//Uint32 colorkey = SDL_MapRGB(SDL_AllocFormat(SDL_PIXELFORMAT_RGBA8888), 255, 255, 255);//white pixel

	SDL_LockTexture(texture, NULL, &pixels, &pitch); 

	//for (int i=0; i < w * h; i++) {
	//	upixels[i] = colorkey;// color all white
	//}
	//memcpy(pixels, upixels, (pitch / 4) * h);

	SDL_UnlockTexture(texture);// OR SDL_UpdateTexture()
	SDL_RenderPresent(renderer);

	Uint32 end = SDL_GetTicks();
	printf("         Delay: %d ms\n", end - start);

	// END -----------------------------
	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window);
	SDL_Quit();
	bcm_host_deinit();
	return 0;
}

