//
// 1360x768 Sony TV
//

#include <SDL.h>
#include <SDL_ttf.h>
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
const int MENU_FONT_SIZE = 24;
const int grey[4] = {0, 25, 100, 255};// dark to white
const char *gamefn[4] {
		"/usr/local/share/gpmd85emu/flappy.bmp",
		"/usr/local/share/gpmd85emu/boulder.bmp",
		"/usr/local/share/gpmd85emu/manic.bmp",
		"/usr/local/share/gpmd85emu/fred.bmp"
	};
const char *gametext[4] {"Flappy", "Boulder Dash", "Manic Miner", "Fred"};

//--- FUNC ---

void RenderText(SDL_Renderer *renderer) {
	TTF_Font *font;
	SDL_Surface* text_surface;
	SDL_Texture* text;
	SDL_Rect text_rect;
	SDL_Color text_color = {255,255,255};

	font = TTF_OpenFont("atari.ttf", MENU_FONT_SIZE);
	text_rect.h = MENU_FONT_SIZE;
	for (int i=0; i < 4; i++) {
		text_surface = TTF_RenderText_Solid(font, gametext[i], text_color);
		text = SDL_CreateTextureFromSurface(renderer, text_surface);
		text_rect.w = 16 * strlen(gametext[i]);
		text_rect.x = MENU_BORDER_X + MENU_SPACING + (MENU_BORDER_WIDTH -text_rect.w) / 2 + i * (MENU_BORDER_WIDTH + MENU_SPACING);
		text_rect.y = MENU_BORDER_Y + MENU_SPACING + MENU_IMAGE_OFFSET + MENU_IMAGE + 29;
		SDL_RenderCopy(renderer, text, NULL, &text_rect);
	}
	SDL_FreeSurface(text_surface);
	SDL_DestroyTexture(text);
}

void RenderImage(SDL_Renderer *renderer) {
	SDL_Surface* bmp;
	SDL_Texture* image;
	SDL_Rect img_rect;
	img_rect.w = MENU_IMAGE;
	img_rect.h = MENU_IMAGE;
	for (int i=0; i < 4; i++) {
		bmp = SDL_LoadBMP(gamefn[i]);
		image = SDL_CreateTextureFromSurface(renderer, bmp);
		img_rect.x = MENU_BORDER_X + MENU_SPACING + MENU_IMAGE_OFFSET + i * (MENU_BORDER_WIDTH + MENU_SPACING);
		img_rect.y = MENU_BORDER_Y + MENU_SPACING + MENU_IMAGE_OFFSET;
		SDL_RenderCopy(renderer, image, NULL, &img_rect);
	}
	SDL_FreeSurface(bmp);
	SDL_DestroyTexture(image);
}

void RenderMenu(SDL_Renderer *renderer, int game_next) {
	SDL_Rect border_rect;
	border_rect.w = MENU_BORDER_WIDTH;
	border_rect.h = MENU_BORDER_HEIGHT;

	RenderImage(renderer);// Render images
	RenderText(renderer);// Render texts

	for (int i=0; i < 4; i++) {
		if ( i != game_next ) { SDL_SetRenderDrawColor(renderer, 25, 25, 25, 255);
	       	} else { SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255); };
		border_rect.x = MENU_BORDER_X + MENU_SPACING + i * (MENU_BORDER_WIDTH + MENU_SPACING);
		border_rect.y = MENU_BORDER_Y + MENU_SPACING;
		SDL_RenderDrawRect(renderer, &border_rect);
	}
	SDL_RenderPresent(renderer);
}

//--- MAIN ---

int main(int argc, char* args[]) {
	bool quit = false;
	int game_next = 0;
	unsigned int nextTime;

	SDL_Window* window = NULL;
	SDL_Renderer* renderer = NULL;
	SDL_Event event;
	TTF_Font *font = NULL;
	//SDL_RendererInfo driver;
	//SDL_DisplayMode fullscreen;

	bcm_host_init();// ?

	if(SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER | SDL_INIT_EVENTS) != 0) return 1;
	if(TTF_Init() != 0 ) printf("Font init failed.\n");
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

	RenderMenu(renderer,game_next);

	while(1) {
		nextTime = SDL_GetTicks() + 100;
		while(SDL_PollEvent(&event)) {
			switch(event.type) {
				case SDL_KEYDOWN:
					if (event.key.keysym.sym == SDLK_LEFT) {
						(game_next == 0) ? game_next = 3 : game_next--;
						RenderMenu(renderer,game_next);
					}
					if (event.key.keysym.sym == SDLK_RIGHT) {
						(game_next == 3) ? game_next = 0 : game_next++;
						RenderMenu(renderer, game_next);
					}
					if (event.key.keysym.sym == SDLK_RETURN) {
						quit = true;
						printf("Enter Game: %i\n", game_next);
				       	}
					break;
				default:
					break;
			}
		}
		if (quit) { break; }
		while (SDL_GetTicks() < nextTime) SDL_Delay(1);//prevent CPU exhaustion
	}
	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window);
	SDL_Quit();
	bcm_host_deinit();
	return 0;
}

