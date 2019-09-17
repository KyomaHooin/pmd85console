//
// PMD-85 Emulator Menu [1360x768 Sony TV]
//

#include <SDL.h>
#include <SDL_ttf.h>
#include <stdio.h>

//--- DEF ---

const char *menuText[6] = {
  "PMD-85 Retro console",
  "1] Vyber hru pomoci sipek <-, -> a stiskni [enter].",
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

const char *gameText[4] {"FLAPPY", "BOULDER", "MANIC", "FRED"};

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
// Menu timer
SDL_TimerID menuTimer;

//----------------------------------------------- FUNC ---

// Render menu text
void RenderText(SDL_Renderer *renderer) {
  TTF_Font *textFont;
  SDL_Surface* textSurface;
  SDL_Texture* textTexture;
  SDL_Rect textRectangle;
  SDL_Rect gameTextRectangle;
  SDL_Color textColor = {255,255,255};// white

  textFont = TTF_OpenFont("atari-classic.ttf", 24);

  //Copy right
  textSurface = TTF_RenderText_Solid(textFont, menuText[5], textColor);
  textTexture = SDL_CreateTextureFromSurface(renderer, textSurface);

  textRectangle.h = 24;
  textRectangle.w = 16 * strlen(menuText[5]);
  textRectangle.x = 100;
  textRectangle.y = 600;
 
  SDL_RenderCopy(renderer, textTexture, NULL, &textRectangle);

  //Game text
  for (int i = 0; i < 4; i++) {
    textSurface = TTF_RenderText_Solid(textFont, gameText[i], textColor);
    textTexture = SDL_CreateTextureFromSurface(renderer, textSurface);

    textRectangle.h = 24;
    textRectangle.w = 16 * strlen(gameText[i]);
    textRectangle.x = 100 + i * (174 + 26) + (174 - 16 * strlen(gameText[i])) / 2;
    textRectangle.y = 300 + 174 + (260 - 174 - 13) / 2;

    SDL_RenderCopy(renderer, textTexture, NULL, &textRectangle);
  }
  //Help text
  for (int i = 0; i < 5; i++) {
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

// Render menu images
void RenderImage(SDL_Renderer *renderer) {
  SDL_Surface* imageSurface;
  SDL_Texture* imageTexture;
  SDL_Rect imageRectangle;

  for (int i = 0; i < 4; i++) {
    imageSurface = SDL_LoadBMP(gameFile[i]);
    imageTexture = SDL_CreateTextureFromSurface(renderer, imageSurface);
 
    imageRectangle.w = 174;
    imageRectangle.h = 174;
    imageRectangle.x = 100 + i * (174 + 26);// 26-px h-spacing
    imageRectangle.y = 300;
  
    SDL_RenderCopy(renderer, imageTexture, NULL, &imageRectangle);
  }
  SDL_FreeSurface(imageSurface);
  SDL_DestroyTexture(imageTexture);
}

// Render complete menu and game select frame
void RenderMenu(SDL_Renderer *renderer, int gameIndex) {
  SDL_Rect frameRectangle;

 for (int i = 0; i < 4; i++) {
    frameRectangle.w = 200;
    frameRectangle.h = 200;
    frameRectangle.x = 100 - 13 + i * 200;// 0-px h-spacing
    frameRectangle.y = 300 - 13;
    if (i == gameIndex) {
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);// white frame
    } else {
      SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);// black frame
    }
    SDL_RenderDrawRect(renderer, &frameRectangle);
  }
  RenderText(menuRenderer);
  RenderImage(menuRenderer);
  // Present complete menu
  SDL_RenderPresent(renderer);
}

// Run game
//void EmulatorRun(int game_next) {
//	//Emulator init
//	//Emulator loop
//	//Emulator exit
//}

//Menu timer callback function
//Uint32 menuTimerCallback (Uint32 menuInterval, void *pArgs) {
//  SDL_Event menuEvent;
//  menuEvent.type = SDL_USEREVENT;
//  menuEvent.user.code = 1;
//  menuEvent.user.data1 = NULL;
//  menuEvent.user.data2 = NULL;
//  SDL_PushEvent (&menuEvent);
//
//  return menuInterval;
//}

//
//------------------------------------------------------ MAIN ---
//

int main(int argc, char* args[]) {

  if(SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER | SDL_INIT_EVENTS) != 0) return 1;
  printf("SDL: done..\n");

  if(TTF_Init() != 0 ) printf("Font init failed.\n");
  printf("TTF: done..\n");
	
  mainWindow = SDL_CreateWindow("PMD-85", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 200, 200, 0);
  if(mainWindow == NULL) printf("Window init error.\n");
  printf("Window: done..\n");

  menuRenderer = SDL_CreateRenderer(mainWindow, 0, SDL_RENDERER_ACCELERATED);//SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_TARGETTEXTURE
  if(menuRenderer == NULL) printf("Renderer init error.\n");
  printf("Renderer: done..\n");
  //Disable cursor
  SDL_ShowCursor(SDL_DISABLE);
  //CLRSCR
  SDL_SetRenderDrawColor(menuRenderer,0,0,0,SDL_ALPHA_OPAQUE);
  SDL_RenderClear(menuRenderer);	
  SDL_RenderPresent(menuRenderer);
  // Prepare static content
  RenderText(menuRenderer);
  RenderImage(menuRenderer);
  //Render game frame..
  RenderMenu(menuRenderer,0);
  //menuTimer = SDL_AddTimer(40, menuTimerCallback, NULL);// 40ms  menu refresh timer ..

  while(!emulatorQuit) {
		
 //   nextTime = SDL_GetTicks() + 100;
	
    SDL_WaitEvent(&sEvent);
    switch(sEvent.type) {
      //case SDL_KEYUP:
      case SDL_KEYDOWN:
        if (inMenu) {
          if (sEvent.key.keysym.sym == SDLK_LEFT) {
            (gameIndex == 0) ? gameIndex = 3 : gameIndex--;
            printf("Current index.. %i\n", gameIndex);
            RenderMenu(menuRenderer, gameIndex);// redraw frame
	  }
          if (sEvent.key.keysym.sym == SDLK_RIGHT) {
            (gameIndex == 3) ? gameIndex = 0 : gameIndex++;
            printf("Current index.. %i\n", gameIndex);
            RenderMenu(menuRenderer, gameIndex);// redraw frame
	  }
          if (sEvent.key.keysym.sym == SDLK_RETURN) {
            printf("Running emualor %i\n", gameIndex);
	    inMenu = false;
	  }
	}
        if (sEvent.key.keysym.sym == SDLK_ESCAPE) {
          if(inMenu) {
            emulatorQuit = true;
	  } else {
            printf("Returing to menu..\n");
	    inMenu = true;
	  }
        }
        break;
//      case SDL_USEREVENT:
//        if (sEvent.user.code == 1) {// menu rendering..
//          RenderMenu(menuRenderer, gameIndex);
//        }
//      break;
    }

    //Re-render menu
  //  RenderMenu(menuRenderer,gameIndex);
  //  while (SDL_GetTicks() < nextTime) SDL_Delay(1);//prevent CPU exhaustion
  }

  //SDL_RemoveTimer(menuTimer);

  //QUIT
  SDL_DestroyRenderer(menuRenderer);
  SDL_DestroyWindow(mainWindow);
  SDL_Quit();

  return 0;

}

