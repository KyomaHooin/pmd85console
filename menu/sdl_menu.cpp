//
// 1360x768 Sony TV
//

#include <SDL.h>
#include <stdio.h>
#include <bcm_host.h>

//--- DEF ---

const int MENU_WIDTH = 900;
const int MENU_HEIGHT = 300;
const int MENU_BORDER_WIDTH = 200;
const int MENU_BORDER_HEIGHT = 260;
const int MENU_SPACING = 20;
const int MENU_BORDER_X = (1360 - MENU_WIDTH) / 2;
const int MENU_BORDER_Y = (768 - MENU_HEIGHT) / 2 ;
const int MENU_IMAGE = 174;
const int MENU_IMAGE_OFFSET = (MENU_BORDER_WIDTH - MENU_IMAGE) / 2;
const int grey[4] = {0, 25, 100, 255};// dark to white
const char *gamefn[4] {
		"/usr/local/share/gpmd85emu/flappy.bmp",
		"/usr/local/share/gpmd85emu/boulder.bmp",
		"/usr/local/share/gpmd85emu/manic.bmp",
		"/usr/local/share/gpmd85emu/fred.bmp"
	};

//--- FUNC ---

void Highlight(SDL_Renderer *renderer, int game, int color) {
	SDL_Rect border_rect;

	border_rect.w = MENU_BORDER_WIDTH;
	border_rect.h = MENU_BORDER_HEIGHT;

	SDL_SetRenderDrawColor(renderer, grey[color], grey[color], grey[color], 255);

	border_rect.x = MENU_BORDER_X + MENU_SPACING + game * (MENU_BORDER_WIDTH + MENU_SPACING);
	border_rect.y = MENU_BORDER_Y + MENU_SPACING;

	SDL_RenderDrawRect(renderer,&border_rect);
	SDL_RenderPresent(renderer);
}

void RenderMenuDefault(SDL_Renderer *renderer) {
	SDL_Surface* bmp = NULL;
	SDL_Texture* image = NULL;
	SDL_Rect img_rect,border_rect;

	img_rect.w = MENU_IMAGE;
	img_rect.h = MENU_IMAGE;
	border_rect.w = MENU_BORDER_WIDTH;
	border_rect.h = MENU_BORDER_HEIGHT;

	SDL_SetRenderDrawColor(renderer, 25, 25, 25, 255);// border color

	image = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_STATIC, MENU_IMAGE, MENU_IMAGE);
	if(image == NULL) {
		printf("Image texture init error.\n");
	}

	for (int i=0; i < 4; i++) {
		bmp = SDL_LoadBMP(gamefn[i]);
		image = SDL_CreateTextureFromSurface(renderer, bmp);
		img_rect.x = MENU_BORDER_X + MENU_SPACING + MENU_IMAGE_OFFSET + i * (MENU_BORDER_WIDTH + MENU_SPACING);
		img_rect.y = MENU_BORDER_Y + MENU_SPACING + MENU_IMAGE_OFFSET;

		SDL_RenderCopy(renderer, image, NULL, &img_rect);

		border_rect.x = MENU_BORDER_X + MENU_SPACING + i * (MENU_BORDER_WIDTH + MENU_SPACING);
		border_rect.y = MENU_BORDER_Y + MENU_SPACING;

		SDL_RenderDrawRect(renderer,&border_rect);
	}
	SDL_RenderPresent(renderer);
	SDL_FreeSurface(bmp);
	SDL_DestroyTexture(image);
}

//--- MAIN ---

int main(int argc, char* args[]) {
	bool quit = false;
	int game = 0, color = 0;
	unsigned int nextTime;

	SDL_Window* window = NULL;
	SDL_Renderer* renderer = NULL;
	SDL_Event event;

	//SDL_RendererInfo driver;
	//SDL_DisplayMode fullscreen;

	bcm_host_init();// ?

	if(SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER | SDL_INIT_EVENTS) != 0) return 1;
	//if(SDL_GetRenderDriverInfo(0,&driver) != 0) printf("Failed to get driver info.");

	//printf("Current driver: %s\n",driver.name);
	//printf("      Software: %c\n",(driver.flags & SDL_RENDERER_SOFTWARE) ? 'x': ' ');
	//printf("   Accelerated: %c\n",(driver.flags & SDL_RENDERER_ACCELERATED) ? 'x': ' ');
	//printf("  Presentvsync: %c\n",(driver.flags & SDL_RENDERER_PRESENTVSYNC) ? 'x': ' ');
	//printf(" Targettexture: %c\n",(driver.flags & SDL_RENDERER_TARGETTEXTURE) ? 'x': ' ');
	//if(SDL_GetDesktopDisplayMode(0,&fullscreen) != 0) printf("Get resoultion failed.");

	window = SDL_CreateWindow("Menu", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 200, 200, SDL_WINDOW_SHOWN | SDL_WINDOW_FULLSCREEN);
	if(window == NULL) printf("Window init error.\n");

	SDL_ShowCursor(SDL_DISABLE);

	renderer = SDL_CreateRenderer(window, 0, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_TARGETTEXTURE);
	if(renderer == NULL) printf("Renderer init error.\n");

	//printf("Resolution: %d x %d \n",fullscreen.w, fullscreen.h);

	SDL_ShowWindow(window);
	SDL_RenderPresent(renderer);// ?
	SDL_SetRenderDrawColor(renderer,0,0,0,255);
	SDL_RenderClear(renderer);// clrscr	

	RenderMenuDefault(renderer);//menu default

	while(1) {
		nextTime = SDL_GetTicks() + 500;//highlight delay 500ms
		while(SDL_PollEvent(&event)) {
			switch(event.type) {
				case SDL_KEYDOWN:
					if (event.key.keysym.sym == SDLK_LEFT) {
						(game != 0) ? game-- : game = 3;
						printf("Left pressed. Game: %i ", game);
					}
					if (event.key.keysym.sym == SDLK_RIGHT) {
						(game == 3) ? game = 0 : game++;
						printf("Right pressed. Game: %i ", game);
					}
					if (event.key.keysym.sym == SDLK_RETURN) {
						quit = true;
						printf("Enter Game: %i\n", game);
				       	}
					break;
				default:
					break;
			}
		}

		if (quit) { break; }

		printf("Highlighting, game: %i color: %i\n", game, color);
		Highlight(renderer, game, color);
		(color == 3) ? color = 0 : color++;
	
		while (SDL_GetTicks() < nextTime) SDL_Delay(1);//prevent CPU exhaustion
	}
	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window);
	SDL_Quit();
	bcm_host_deinit();
	return 0;
}

