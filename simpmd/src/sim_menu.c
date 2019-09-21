/*

SIM_MENU.C

Copything (c) 2019 - Richard Bruna

Simple poor-man PMD-85 game selection menu

*/

#include <SDL2/SDL_ttf.h>

//-----

#define FONT_HEIGHT      24
#define FONT_WIDTH       16
#define IMAGE_WIDTH     174
#define FRAME_WIDTH     200
#define FRAME_SPACE       5
#define MENU_WIDTH      815 //4x200 + 3x 5px spacing

//----------------------------------------------------------------------
//
// HARDCODED DATA
//

const char *menuText[6] = {
  "PMD-85 Retro console",
  "1] Vyber hru pomoci sipek <-, -> a stiskni [enter].",
  "2] Pro spusteni hry napis 'MGLD 03' a stiskni [enter].",
  "3] Pro ukonceni hry stiskni [esc].",
  "4] Pro konec stiskni [esc].",
  "[ Richard Bruna (c) 2019 ]"
};

const char *gameFile[4] = {
  "/root/simpmd-develop/data/logo/flappy.bmp",
  "/root/simpmd-develop/data/logo/boulder.bmp",
  "/root/simpmd-develop/data/logo/manic.bmp",
  "/root/simpmd-develop/data/logo/fred.bmp"
};

const char *gameText[4] = {"FLAPPY", "BOULDER", "MANIC", "FRED"};

//------------------------------------------------------------------------
//
// Copy TTF text data to renderer
//

// Render menu text
void RenderText(SDL_Renderer *renderer, int screen_width, int screen_height) {
  TTF_Font *textFont;
  SDL_Surface* textSurface;
  SDL_Texture* textTexture;
  SDL_Rect textRectangle;
  SDL_Rect gameTextRectangle;
  SDL_Color textColor = {255,255,255};// white

  textFont = TTF_OpenFont("/root/simpmd-develop/data/font/atari-classic.ttf", FONT_HEIGHT);

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
//------------------------------------------------------------------------
//
// Copy BMP image data to renderer
//
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
//------------------------------------------------------------------------
//
// Copy menu selection frame, text, images data and update renderer 
//
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
      SDL_SetRenderDrawColor(renderer, 255, 255, 255, SDL_ALPHA_OPAQUE);
    } else {
      SDL_SetRenderDrawColor(renderer, 0, 0, 0, SDL_ALPHA_OPAQUE);
    }
    SDL_RenderDrawRect(renderer, &frameRectangle);
    SDL_RenderDrawRect(renderer, &frameRectangleIn);
  }
  RenderText(renderer,screen_width,screen_height);
  RenderImage(renderer,screen_width,screen_height);
 
  SDL_RenderPresent(renderer);
}

