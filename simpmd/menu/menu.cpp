//
// PMD-85 Emulator Menu [1360x768 Sony TV]
//

#include <SDL.h>
#include <SDL_ttf.h>
#include <stdio.h>

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
		"/root/menu/logo/flappy.bmp",
		"/root/menu/logo/boulder.bmp",
		"/root/menu/logo/manic.bmp",
		"/root/menu/logo/fred.bmp"
	};

const char *gametext[4] {"Flappy", "Boulder", "Manic", "Fred"};

// Menu
bool emulatorQuit = false;
bool inMenu = true;
int gameIndex = 0;
unsigned int nextTime;

// Main window
SDL_Window* mainWindow;
// Menu renderer
SDL_Renderer* menuRenderer;
// Event handler
SDL_Event sEvent;
// TTF menu font
TTF_Font *menuFont;

//----------------------------------------------- FUNC ---
//
//void RenderText(SDL_Renderer *renderer) {
//	TTF_Font *font;
//	SDL_Surface* text_surface;
//	SDL_Texture* text;
//	SDL_Rect text_rect;
//	SDL_Color text_color = {255,255,255};

//	font = TTF_OpenFont("arcade.ttf", MENU_FONT_SIZE);
//	text_rect.h = MENU_FONT_SIZE;
//	for (int i=0; i < 4; i++) {
//		text_surface = TTF_RenderText_Solid(font, gametext[i], text_color);
//		text = SDL_CreateTextureFromSurface(renderer, text_surface);
//		text_rect.w = 16 * strlen(gametext[i]);
//		text_rect.x = MENU_BORDER_X + MENU_SPACING + (MENU_BORDER_WIDTH -text_rect.w) / 2 + i * (MENU_BORDER_WIDTH + MENU_SPACING);
//		text_rect.y = MENU_BORDER_Y + MENU_SPACING + MENU_IMAGE_OFFSET + MENU_IMAGE + 29;
//		SDL_RenderCopy(renderer, text, NULL, &text_rect);
//	}
//	SDL_FreeSurface(text_surface);
//	SDL_DestroyTexture(text);
//}

//void RenderImage(SDL_Renderer *renderer) {
//	SDL_Surface* bmp;
//	SDL_Texture* image;
//	SDL_Rect img_rect;
//	img_rect.w = MENU_IMAGE;
//	img_rect.h = MENU_IMAGE;
//	for (int i=0; i < 4; i++) {
//		bmp = SDL_LoadBMP(gamefn[i]);
//		image = SDL_CreateTextureFromSurface(renderer, bmp);
//		img_rect.x = MENU_BORDER_X + MENU_SPACING + MENU_IMAGE_OFFSET + i * (MENU_BORDER_WIDTH + MENU_SPACING);
//		img_rect.y = MENU_BORDER_Y + MENU_SPACING + MENU_IMAGE_OFFSET;
//		SDL_RenderCopy(renderer, image, NULL, &img_rect);
//	}
//	SDL_FreeSurface(bmp);
//	SDL_DestroyTexture(image);
//}

//void RenderMenu(SDL_Renderer *renderer, int game_next) {
//	SDL_Rect border_rect;
//	border_rect.w = MENU_BORDER_WIDTH;
//	border_rect.h = MENU_BORDER_HEIGHT;
//
//	RenderImage(renderer);// Render images
//	RenderText(renderer);// Render texts
//
//	for (int i=0; i < 4; i++) {
//		if ( i != game_next ) { SDL_SetRenderDrawColor(renderer, 25, 25, 25, 255);
//	       	} else { SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255); };
//		border_rect.x = MENU_BORDER_X + MENU_SPACING + i * (MENU_BORDER_WIDTH + MENU_SPACING);
//		border_rect.y = MENU_BORDER_Y + MENU_SPACING;
//		SDL_RenderDrawRect(renderer, &border_rect);
//	}
//	SDL_RenderPresent(renderer);
//}


void EmulatorRun(int game_next) {
	//Emulator init
	//Emulator loop
	//Emulator exit
}

void menuInit() {
	menuRenderer = SDL_CreateRenderer(mainWindow, 0, SDL_RENDERER_ACCELERATED);
	//renderer = SDL_CreateRenderer(window, 0, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_TARGETTEXTURE);
	//if(renderer == NULL) printf("Renderer init error.\n");
	//Disable cursor
	SDL_ShowCursor(SDL_DISABLE);
	//CLRSCR
	SDL_SetRenderDrawColor(menuRenderer,0,0,0,SDL_ALPHA_OPAQUE);
	SDL_RenderClear(menuRenderer);	
	SDL_RenderPresent(menuRenderer);
}

void menuQuit() {
	SDL_DestroyRenderer(menuRenderer);
}

//
//------------------------------------------------------ MAIN ---
//

int main(int argc, char* args[]) {

  if(SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER | SDL_INIT_EVENTS) != 0) return 1;

  if(TTF_Init() != 0 ) printf("Font init failed.\n");
	
  mainWindow = SDL_CreateWindow("PMD-85", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 200, 200, 0);
  //if(window == NULL) printf("Window init error.\n");

  menuInit();

  while(!emulatorQuit) {
		
    nextTime = SDL_GetTicks() + 100;
	
    SDL_PollEvent(&sEvent);
    switch(sEvent.type) {
      //case SDL_KEYUP:
      case SDL_KEYDOWN:
        if (inMenu) {
          if (sEvent.key.keysym.sym == SDLK_LEFT) { (gameIndex == 0) ? gameIndex = 3 : gameIndex--; }
          if (sEvent.key.keysym.sym == SDLK_RIGHT) { (gameIndex == 3) ? gameIndex = 0 : gameIndex++; }
          if (sEvent.key.keysym.sym == SDLK_RETURN) { printf("Enter Game: %i\n", gameIndex); }// run game
          if (sEvent.key.keysym.sym == SDLK_ESCAPE) { emulatorQuit = true; };
	}
      break;
    }
    while (SDL_GetTicks() < nextTime) SDL_Delay(1);//prevent CPU exhaustion
  }

  menuQuit();
  SDL_DestroyWindow(mainWindow);
  SDL_Quit();

  return 0;

}

