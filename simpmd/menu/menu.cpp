//
// PMD-85 Emulator Menu [1360x768 Sony TV]
//

#include <SDL.h>
#include <SDL_ttf.h>
#include <stdio.h>

//--- DEF ---

const char *menuText[6] = {
  "PMD-85 Retro console",
  "1] Vyber hru pomoci sipek [<], [>] a stiskni [enter].",
  "2] Pro spusteni hry napis 'MGLD 03' a stiskni [enter].",
  "3] Pro ukonceni hry stiskni [esc].",
  "4] Pro konec stiskni [esc].",
  "Okabe Rintarou (c) 2019"
};

const char *gameFile[4] {
		"/root/simpmd-develop/menu/logo/flappy.bmp",
		"/root/simpmd-develop/menu/logo/boulder.bmp",
		"/root/simpmd-develop/menu/logo/manic.bmp",
		"/root/simpmd-develop/menu/logo/fred.bmp"
	};

const char *gametext[4] {"FLAPPY", "BOULDER", "MANIC", "FRED"};

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

//----------------------------------------------- FUNC ---
//
void RenderText(SDL_Renderer *renderer) {
  TTF_Font *textFont;
  SDL_Surface* textSurface;
  SDL_Texture* textTexture;
  SDL_Rect textRectangle;
  SDL_Color textColor = {255,255,255};// white

  //textFont = TTF_OpenFont("arcade.ttf", 24);
  textFont = TTF_OpenFont("atari.ttf", 24);

  for (int i = 0; i < 4; i++) {
    textSurface = TTF_RenderText_Solid(textFont, menuText[i], textColor);
    textTexture = SDL_CreateTextureFromSurface(renderer, textSurface);

    textRectangle.h = 24;
    textRectangle.w = 16 * strlen(menuText[i]);
    textRectangle.x = 100;
    textRectangle.y = 100 + i * 26;// 2-px v-spacing 

    SDL_RenderCopy(renderer, textTexture, NULL, &textRectangle);
  }
  SDL_FreeSurface(textSurface);
  SDL_DestroyTexture(textTexture);
}

void RenderImage(SDL_Renderer *renderer) {
  SDL_Surface* imageSurface;
  SDL_Texture* imageTexture;
  SDL_Rect imageRectangle;

  for (int i = 0; i < 5; i++) {
    imageSurface = SDL_LoadBMP(gameFile[i]);
    imageTexture = SDL_CreateTextureFromSurface(renderer, imageSurface);
 
    imageRectangle.w = 174;
    imageRectangle.h = 174;
    imageRectangle.x = 100 + i * 184;// 10-px h-spacing
    imageRectangle.y = 200;
  
    SDL_RenderCopy(renderer, imageTexture, NULL, &imageRectangle);
  }

  SDL_FreeSurface(imageSurface);
  SDL_DestroyTexture(imageTexture);
}

void RenderMenu(SDL_Renderer *renderer, int gameIndex) {
	SDL_Rect frameRectangle;

	frameRectangle.w = 200;
	frameRectangle.h = 260;
	frameRectangle.x = 87;
	frameRectangle.y = 187;
	// Prepare static content
	RenderText(renderer);
	RenderImage(renderer);
	// Selected game restangle
	SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);// white frame
	SDL_RenderDrawRect(renderer, &frameRectangle);
	//Present All the content
	SDL_RenderPresent(renderer);
}


void EmulatorRun(int game_next) {
	//Emulator init
	//Emulator loop
	//Emulator exit
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
  if(mainWindow == NULL) printf("Window init error.\n");

  menuRenderer = SDL_CreateRenderer(mainWindow, 0, SDL_RENDERER_ACCELERATED);//SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_TARGETTEXTURE
  if(menuRenderer == NULL) printf("Renderer init error.\n");
  //Disable cursor
  SDL_ShowCursor(SDL_DISABLE);
  //CLRSCR
  SDL_SetRenderDrawColor(menuRenderer,0,0,0,SDL_ALPHA_OPAQUE);
  SDL_RenderClear(menuRenderer);	
  SDL_RenderPresent(menuRenderer);
 
  RenderMenu(menuRenderer,0);
	  
  while(!emulatorQuit) {
		
    nextTime = SDL_GetTicks() + 100;
	
    SDL_PollEvent(&sEvent);
    switch(sEvent.type) {
      case SDL_KEYUP:
      case SDL_KEYDOWN:
        if (inMenu) {
          if (sEvent.key.keysym.sym == SDLK_LEFT) { (gameIndex == 0) ? gameIndex = 3 : gameIndex--; }
          if (sEvent.key.keysym.sym == SDLK_RIGHT) { (gameIndex == 3) ? gameIndex = 0 : gameIndex++; }
          if (sEvent.key.keysym.sym == SDLK_RETURN) {
            printf("Enter Game: %i\n", gameIndex);// Emulator()
	    inMenu = false;
	  }
	}
        if (sEvent.key.keysym.sym == SDLK_ESCAPE) { emulatorQuit = true; };
        break;
    }
    while (SDL_GetTicks() < nextTime) SDL_Delay(1);//prevent CPU exhaustion
  }

  menuQuit();

  SDL_DestroyWindow(mainWindow);
  SDL_Quit();

  return 0;

}

