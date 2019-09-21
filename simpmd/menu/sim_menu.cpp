//
// PMD-85 Emulator Menu [1360x768 Sony TV]
//

#include <SDL.h>
#include <SDL_ttf.h>
#include <stdio.h>

//--- DEF ---

#define FONT_HEIGHT      24
#define FONT_WIDTH       16
#define IMAGE_WIDTH     174
#define FRAME_WIDTH     200
#define FRAME_SPACE       5
#define MENU_WIDTH      815 //4x200 + 3x 5px spacing

//--- VAR ---

const char *menuText[6] = {
  "PMD-85 Retro console",
  "1] Vyber hru pomoci sipek <-, -> a stiskni [enter].",
  "2] Pro spusteni hry napis 'MGLD 03' a stiskni [enter].",
  "3] Pro ukonceni hry stiskni [esc].",
  "4] Pro konec stiskni [esc].",
  "[ Richard Bruna (c) 2019 ]"
};

const char *gameFile[4] = {
  "/root/simpmd-develop/menu/logo/flappy.bmp",
  "/root/simpmd-develop/menu/logo/boulder.bmp",
  "/root/simpmd-develop/menu/logo/manic.bmp",
  "/root/simpmd-develop/menu/logo/fred.bmp"
};

const char *gameText[4] = {"FLAPPY", "BOULDER", "MANIC", "FRED"};

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
// Display mode
SDL_DisplayMode fullscreen;

//----------------------------------------------- FUNC ---

// Render menu text
void RenderText(SDL_Renderer *renderer, int screen_width, int screen_height) {
  TTF_Font *textFont;
  SDL_Surface* textSurface;
  SDL_Texture* textTexture;
  SDL_Rect textRectangle;
  SDL_Rect gameTextRectangle;
  SDL_Color textColor = {255,255,255};// white

  textFont = TTF_OpenFont("atari-classic.ttf", FONT_HEIGHT);

  //Copy right
  textSurface = TTF_RenderText_Solid(textFont, menuText[5], textColor);
  textTexture = SDL_CreateTextureFromSurface(renderer, textSurface);

  textRectangle.h = FONT_HEIGHT;
  textRectangle.w = FONT_WIDTH * strlen(menuText[5]);
  textRectangle.x = (screen_width - MENU_WIDTH)/2 + (MENU_WIDTH - textRectangle.w)/2;
  textRectangle.y = 650;
 
  SDL_RenderCopy(renderer, textTexture, NULL, &textRectangle);
  //About
  textSurface = TTF_RenderText_Solid(textFont, menuText[0], textColor);
  textTexture = SDL_CreateTextureFromSurface(renderer, textSurface);

  textRectangle.h = FONT_HEIGHT;
  textRectangle.w = FONT_WIDTH * strlen(menuText[0]);
  textRectangle.x = (screen_width - MENU_WIDTH)/2 + (MENU_WIDTH - textRectangle.w)/2;
  textRectangle.y = 100;
 
  SDL_RenderCopy(renderer, textTexture, NULL, &textRectangle);
  //Help text
  for (int i = 1; i < 5; i++) {
    textSurface = TTF_RenderText_Solid(textFont, menuText[i], textColor);
    textTexture = SDL_CreateTextureFromSurface(renderer, textSurface);

    textRectangle.h = FONT_HEIGHT;
    textRectangle.w = FONT_WIDTH * strlen(menuText[i]);
    textRectangle.x = (screen_width - MENU_WIDTH)/2;
    textRectangle.y = 100 + FONT_HEIGHT + 2 + i * (FONT_HEIGHT + 2);// 2-px v-spacing 

    SDL_RenderCopy(renderer, textTexture, NULL, &textRectangle);
  }
  //Game text
  for (int i = 0; i < 4; i++) {
    textSurface = TTF_RenderText_Solid(textFont, gameText[i], textColor);
    textTexture = SDL_CreateTextureFromSurface(renderer, textSurface);

    textRectangle.h = FONT_HEIGHT;
    textRectangle.w = FONT_WIDTH * strlen(gameText[i]);
    textRectangle.x = (screen_width - MENU_WIDTH)/2 + (FRAME_WIDTH - textRectangle.w)/2 + i * (FRAME_WIDTH + FRAME_SPACE);
    textRectangle.y = 300 + FRAME_WIDTH + 15;// 15px text spacing

    SDL_RenderCopy(renderer, textTexture, NULL, &textRectangle);
  }

  SDL_FreeSurface(textSurface);
  SDL_DestroyTexture(textTexture);
}

// Render menu images
void RenderImage(SDL_Renderer *renderer, int screen_width, int screen_height) {
  SDL_Surface* imageSurface;
  SDL_Texture* imageTexture;
  SDL_Rect imageRectangle;

  for (int i = 0; i < 4; i++) {
    imageSurface = SDL_LoadBMP(gameFile[i]);
    imageTexture = SDL_CreateTextureFromSurface(renderer, imageSurface);
 
    imageRectangle.w = IMAGE_WIDTH;
    imageRectangle.h = imageRectangle.w;
    imageRectangle.x = (screen_width - MENU_WIDTH)/2 + 13 + i * (IMAGE_WIDTH + 26 + FRAME_SPACE);// 13-px spacing
    imageRectangle.y = 313;
  
    SDL_RenderCopy(renderer, imageTexture, NULL, &imageRectangle);
  }
  SDL_FreeSurface(imageSurface);
  SDL_DestroyTexture(imageTexture);
}

// Render complete menu and game select frame
void RenderMenu(SDL_Renderer *renderer, int gameIndex, int screen_width, int screen_height) {
  SDL_Rect frameRectangle;
  SDL_Rect frameRectangleIn;

 for (int i = 0; i < 4; i++) {
    frameRectangle.w = 200;
    frameRectangle.h = 260;
    frameRectangle.x = (screen_width - MENU_WIDTH)/2 + i *(FRAME_WIDTH + FRAME_SPACE);
    frameRectangle.y = 300;

    frameRectangleIn.w = 198;
    frameRectangleIn.h = 258;
    frameRectangleIn.x = (screen_width - MENU_WIDTH)/2 + 1 + i *(FRAME_WIDTH + FRAME_SPACE);
    frameRectangleIn.y = 300 + 1;

    if (i == gameIndex) {
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, SDL_ALPHA_OPAQUE);// white frame
    } else {
      SDL_SetRenderDrawColor(renderer, 0, 0, 0, SDL_ALPHA_OPAQUE);// black frame
    }
    SDL_RenderDrawRect(renderer, &frameRectangle);
    SDL_RenderDrawRect(renderer, &frameRectangleIn);
  }
  RenderText(renderer,screen_width,screen_height);
  RenderImage(renderer,screen_width,screen_height);
  // Present complete menu
  SDL_RenderPresent(renderer);
}

//
//------------------------------------------------------ MAIN ---
//

int main(int argc, char* args[]) {

  if(SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER | SDL_INIT_EVENTS) != 0) return 1;
  printf("SDL: done..\n");

  if(TTF_Init() != 0 ) printf("Font init failed.\n");
  printf("TTF: done..\n");

  if(SDL_GetCurrentDisplayMode(0,&fullscreen) != 0) printf("Display mode failed.\n");
  printf("Screen width: %i\n",fullscreen.w);
  printf("Screen height: %i\n",fullscreen.h);

  mainWindow = SDL_CreateWindow("PMD-85", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 200, 200, 0);
  if(mainWindow == NULL) printf("Window init error.\n");
  printf("Window: done..\n");

  menuRenderer = SDL_CreateRenderer(mainWindow, 0, SDL_RENDERER_ACCELERATED);//SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_TARGETTEXTURE
  if(menuRenderer == NULL) printf("Renderer init error.\n");
  printf("Renderer: done..\n");
  //Disable cursor
  SDL_ShowCursor(SDL_DISABLE);
  //CLRSCR
  SDL_SetRenderDrawColor(menuRenderer,0,0,0,SDL_ALPHA_OPAQUE);// black
  SDL_RenderClear(menuRenderer);	
  SDL_RenderPresent(menuRenderer);
  // Menu
  RenderMenu(menuRenderer,0,fullscreen.w,fullscreen.h);

  while(!emulatorQuit) {
    SDL_WaitEvent(&sEvent);
    switch(sEvent.type) {
      //case SDL_KEYUP:
      case SDL_KEYDOWN:
        if (inMenu) {
          if (sEvent.key.keysym.sym == SDLK_LEFT) {
            (gameIndex == 0) ? gameIndex = 3 : gameIndex--;
            //printf("Current index.. %i\n", gameIndex);
            RenderMenu(menuRenderer, gameIndex,fullscreen.w,fullscreen.h);// redraw frame
	  }
          if (sEvent.key.keysym.sym == SDLK_RIGHT) {
            (gameIndex == 3) ? gameIndex = 0 : gameIndex++;
            //printf("Current index.. %i\n", gameIndex);
            RenderMenu(menuRenderer, gameIndex,fullscreen.w,fullscreen.h);// redraw frame
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
    }
  }

  //QUIT
  SDL_DestroyRenderer(menuRenderer);
  SDL_DestroyWindow(mainWindow);
  SDL_Quit();

  return 0;

}

