/*

SIM_DISPLAY.C

Copyright 2008 Petr Tuma

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/

#include "sim_common.h"
#include "SDL2/SDL_ttf.h"


//-------------------------------------------------------------------------------------------------------

#define FONT_HEIGHT      24
#define FONT_WIDTH       16
#define IMAGE_WIDTH     174
#define FRAME_WIDTH     200
#define FRAME_SPACE       5
#define MENU_WIDTH      815 //4x200 + 3x 5px spacing

//-------------------------------------------------------------------------------------------------------
//
// HARDCODED DATA


static const char *menuText[6] = {
  "PMD-85 Retro console",
  "1] Vyber hru pomoci sipek <- -> a stiskni [ Enter ].",
  "2] Pro spusteni hry napis 'MGLD 03' a stiskni [ Enter ].",
  "3] Pro ukonceni hry stiskni [ Esc ].",
  "4] Pro konec stiskni [ Esc ].",
  "Richard Bruna (c) 2019"
};

static const char *gameFile[4] = {
  "/root/simpmd-develop/data/logo/flappy.bmp",
  "/root/simpmd-develop/data/logo/boulder.bmp",
  "/root/simpmd-develop/data/logo/manic.bmp",
  "/root/simpmd-develop/data/logo/fred.bmp"
};

static const char *gameText[4] = {"FLAPPY", "BOULDER", "MANIC", "FRED"};

static const char *gameFont[1] = {"/root/simpmd-develop/data/font/atari-classic.ttf"};


//--------------------------------------------------------------------------
// Command Line Options

/// Screen refresh. How many milliseconds per screen refresh.
static int iArgRefresh = 40;


//--------------------------------------------------------------------------
// Data

/// Singleton screen window.
static SDL_Window *pWindow;
/// Singleton screen renderer;
static SDL_Renderer *pRenderer;
/// Singleton screen texture;
static SDL_Texture *pTexture;
/// Singleton menu window.
static SDL_Window *mWindow;
/// Singleton menu renderer;
static SDL_Renderer *mRenderer;
/// Paint timer.
static SDL_TimerID iPaintTimer;

// Display colors.
#define DSP_COLOR_BLACK 0b00000000
#define DSP_COLOR_WHITE 0b11111111
#define DSP_COLOR_GRAY  0b10010010

/// Base address of the video memory.
#define PMD_VRAM_BASE           0xC000
/// Width of the visible video memory line in bytes.
#define PMD_VRAM_WIDTH          48
/// Width of the invisible video memory line in bytes.
#define PMD_VRAM_BLANK          16
/// Height of the video memory area in lines.
#define PMD_VRAM_HEIGHT         256

/// Number of pixels in one byte.
#define PMD_PIXEL_COUNT         6
/// Gray attribute mask.
#define PMD_PIXEL_GRAY          (1 << 6)
/// Blinking attribute bask.
#define PMD_PIXEL_BLINK         (1 << 7)

/// Blinking rate in miliseconds.
#define PMD_BLINK_RATE          512


/// Rendered screen data.
static byte abScreenData [PMD_VRAM_WIDTH * PMD_PIXEL_COUNT * PMD_VRAM_HEIGHT];


//--------------------------------------------------------------------------
// Screen paint

/** Determine whether blinking pixels are visible.
 *
 *  Visibility of blinking pixels is based on actual time.
 *
 *  @return Flag determining blinking pixel visibility.
 */
bool DSPBlinkVisible ()
{
  return ((SDL_GetTicks () / PMD_BLINK_RATE) & 1);
}


/** Decode the screen content in 1:1 zoom.
 *
 *  Decodes the memory content of the simulated machine using
 *  direct writing to screen texture. Optimized for 1:1 zoom.
 */
void DSPDecodeScreen ()
{
  bool bBlinkVisible = DSPBlinkVisible ();

  // Traverse the memory content line by line and byte by byte
  // and paint the screen content as we go.
  byte *pSource = abMemoryData + PMD_VRAM_BASE;
  byte *pTarget = abScreenData;
  for (int iLine = 0 ; iLine < PMD_VRAM_HEIGHT ; iLine ++)
  {
    for (int iByte = 0 ; iByte < PMD_VRAM_WIDTH ; iByte ++)
    {
      byte iData = *pSource;

      // Determine the drawing color. All pixels in one byte share color.
      byte iColor = (iData & PMD_PIXEL_GRAY) ? iColor = DSP_COLOR_GRAY
                                             : iColor = DSP_COLOR_WHITE;
      if ((iData & PMD_PIXEL_BLINK) && !bBlinkVisible) iColor = DSP_COLOR_BLACK;

      // The inner cycle is unrolled for speed.

#define DSPPaintPixel                                           \
  *pTarget = (iData & 1) ? iColor : DSP_COLOR_BLACK;            \
  iData >>= 1;                                                  \
  pTarget ++;

      DSPPaintPixel
      DSPPaintPixel
      DSPPaintPixel
      DSPPaintPixel
      DSPPaintPixel
      DSPPaintPixel

#undef DSPPaintPixel

      pSource ++;
    }

    pSource += PMD_VRAM_BLANK;
  }
}


//--------------------------------------------------------------------------
// Event handlers

/** Handler for painting the screen content.
 *
 *  Decodes the memory content of the simulated machine
 *  and paints the screen content accordingly, using
 *  direct writing and double buffering.
 */
void DSPPaintHandler ()
{
  // TODO Consider using HQX ?

  DSPDecodeScreen ();

  // TODO Check if render clear is really needed ?

  SDL_CheckZero (SDL_SetRenderDrawColor (pRenderer, 0, 0, 0, SDL_ALPHA_OPAQUE));
  SDL_CheckZero (SDL_RenderClear (pRenderer));
  SDL_CheckZero (SDL_UpdateTexture (pTexture, NULL, &abScreenData, PMD_VRAM_WIDTH * PMD_PIXEL_COUNT));
  SDL_CheckZero (SDL_RenderCopy (pRenderer, pTexture, NULL, NULL));
  SDL_RenderPresent (pRenderer);
}


//--------------------------------------------------------------------------
// Callback handlers

/** Handler for painting the screen content.
 *
 *  Pushes an event corresponding to the timer on the
 *  event queue to maintain the threading rules.
 */
Uint32 DSPPaintTimerCallback (Uint32 iInterval, void *pArgs)
{
  SDL_Event sEvent;
  sEvent.type = SDL_USEREVENT;
  sEvent.user.code = 0;
  sEvent.user.data1 = NULL;
  sEvent.user.data2 = NULL;
  SDL_PushEvent (&sEvent);

  return (iArgRefresh);
}


//--------------------------------------------------------------------------
// Initialization and shutdown


void DSPInitialize ()
{
  // Initialize the video resources.
  SDL_CheckNotNull (pWindow = SDL_CreateWindow ("SimPMD",SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
                                                PMD_VRAM_WIDTH * PMD_PIXEL_COUNT, PMD_VRAM_HEIGHT,0));
  SDL_CheckNotNull (pRenderer = SDL_CreateRenderer (pWindow, -1, SDL_RENDERER_ACCELERATED));
  SDL_CheckNotNull (pTexture = SDL_CreateTexture (pRenderer, SDL_PIXELFORMAT_RGB332, SDL_TEXTUREACCESS_STREAMING,
                                                  PMD_VRAM_WIDTH * PMD_PIXEL_COUNT, PMD_VRAM_HEIGHT));
  //SDL_CheckTrue (SDL_SetHint (SDL_HINT_RENDER_SCALE_QUALITY, 0));

  // Clear screen.
  SDL_CheckZero (SDL_SetRenderDrawColor (pRenderer, 0, 0, 0, SDL_ALPHA_OPAQUE));
  SDL_CheckZero (SDL_RenderClear (pRenderer));

  SDL_RenderPresent (pRenderer);

  // Start the timer that paints the screen repeatedly ...
  iPaintTimer = SDL_AddTimer (iArgRefresh, DSPPaintTimerCallback, NULL);
}


void DSPMenuInitialize ()
{
  // Initialize the video resources.
  SDL_CheckNotNull (mWindow = SDL_CreateWindow ("SimPMD - Menu",SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
                                                PMD_VRAM_WIDTH * PMD_PIXEL_COUNT, PMD_VRAM_HEIGHT,0));
  SDL_CheckNotNull (mRenderer = SDL_CreateRenderer (mWindow, -1, SDL_RENDERER_ACCELERATED));

  //TTF
  TTF_Init();

  // Clear screen.
  SDL_CheckZero (SDL_SetRenderDrawColor (mRenderer, 0, 0, 0, SDL_ALPHA_OPAQUE));
  SDL_CheckZero (SDL_RenderClear (mRenderer));
  SDL_RenderPresent (mRenderer);
}


void DSPShutdown ()
{
  // Stop the timer that paints the screen repeatedly ...
  SDL_RemoveTimer (iPaintTimer);

  SDL_DestroyTexture (pTexture);
  pTexture = NULL;
  SDL_DestroyRenderer (pRenderer);
  pRenderer = NULL;
  SDL_DestroyWindow (pWindow);
  pWindow = NULL;
}


void DSPMenuShutdown ()
{
  SDL_DestroyRenderer (mRenderer);
  mRenderer = NULL;
  SDL_DestroyWindow (mWindow);
  mWindow = NULL;
}


void DSPRenderText(int screen_width, int screen_height) {
  TTF_Font *textFont;
  SDL_Surface* textSurface;
  SDL_Texture* textTexture;
  SDL_Rect textRectangle;
  SDL_Rect gameTextRectangle;
  SDL_Color textColor = {255,255,255};// white

  textFont = TTF_OpenFont(gameFont[0], FONT_HEIGHT);

  // Copyright
  textSurface = TTF_RenderText_Solid(textFont, menuText[5], textColor);
  textTexture = SDL_CreateTextureFromSurface(mRenderer, textSurface);

  textRectangle.h = FONT_HEIGHT;
  textRectangle.w = FONT_WIDTH * strlen(menuText[5]);
  textRectangle.x = (screen_width - MENU_WIDTH)/2 + (MENU_WIDTH - textRectangle.w)/2;
  textRectangle.y = 665;
 
  SDL_RenderCopy(mRenderer, textTexture, NULL, &textRectangle);
  // About
  textSurface = TTF_RenderText_Solid(textFont, menuText[0], textColor);
  textTexture = SDL_CreateTextureFromSurface(mRenderer, textSurface);

  textRectangle.h = FONT_HEIGHT;
  textRectangle.w = FONT_WIDTH * strlen(menuText[0]);
  textRectangle.x = (screen_width - MENU_WIDTH)/2 + (MENU_WIDTH - textRectangle.w)/2;
  textRectangle.y = 100;
 
  SDL_RenderCopy(mRenderer, textTexture, NULL, &textRectangle);
  // Help text
  for (int i = 1; i < 5; i++) {
    textSurface = TTF_RenderText_Solid(textFont, menuText[i], textColor);
    textTexture = SDL_CreateTextureFromSurface(mRenderer, textSurface);

    textRectangle.h = FONT_HEIGHT;
    textRectangle.w = FONT_WIDTH * strlen(menuText[i]);
    textRectangle.x = (screen_width - MENU_WIDTH)/2;
    textRectangle.y = 100 + FONT_HEIGHT + 2 + i * (FONT_HEIGHT + 2);// 2-px v-spacing 

    SDL_RenderCopy(mRenderer, textTexture, NULL, &textRectangle);
  }
  // Game text
  for (int i = 0; i < 4; i++) {
    textSurface = TTF_RenderText_Solid(textFont, gameText[i], textColor);
    textTexture = SDL_CreateTextureFromSurface(mRenderer, textSurface);

    textRectangle.h = FONT_HEIGHT;
    textRectangle.w = FONT_WIDTH * strlen(gameText[i]);
    textRectangle.x = (screen_width - MENU_WIDTH)/2 + (FRAME_WIDTH - textRectangle.w)/2 + i * (FRAME_WIDTH + FRAME_SPACE);
    textRectangle.y = 310 + FRAME_WIDTH + 15;// 15px text spacing

    SDL_RenderCopy(mRenderer, textTexture, NULL, &textRectangle);
  }

  SDL_FreeSurface(textSurface);
  SDL_DestroyTexture(textTexture);
}


void DSPRenderImage(int screen_width, int screen_height) {
  SDL_Surface* imageSurface;
  SDL_Texture* imageTexture;
  SDL_Rect imageRectangle;

  for (int i = 0; i < 4; i++) {
    imageSurface = SDL_LoadBMP(gameFile[i]);
    imageTexture = SDL_CreateTextureFromSurface(mRenderer, imageSurface);
 
    imageRectangle.w = IMAGE_WIDTH;
    imageRectangle.h = imageRectangle.w;
    imageRectangle.x = (screen_width - MENU_WIDTH)/2 + 13 + i * (IMAGE_WIDTH + 26 + FRAME_SPACE);// 13-px spacing
    imageRectangle.y = 320 + 13;
  
    SDL_RenderCopy(mRenderer, imageTexture, NULL, &imageRectangle);
  }
  SDL_FreeSurface(imageSurface);
  SDL_DestroyTexture(imageTexture);
}


void DSPRenderMenu(int screen_width, int screen_height, int index) {
  SDL_Rect frameRectangle;
  SDL_Rect frameRectangleInner;

  for (int i = 0; i < 4; i++) {
    frameRectangle.w = 200;
    frameRectangle.h = 260;
    frameRectangle.x = (screen_width - MENU_WIDTH)/2 + i *(FRAME_WIDTH + FRAME_SPACE);
    frameRectangle.y = 320;

    frameRectangleInner.w = 198;
    frameRectangleInner.h = 258;
    frameRectangleInner.x = (screen_width - MENU_WIDTH)/2 + 1 + i *(FRAME_WIDTH + FRAME_SPACE);
    frameRectangleInner.y = 320 + 1;

    if (i == index) { SDL_SetRenderDrawColor(mRenderer, 255, 255, 255, SDL_ALPHA_OPAQUE);
    } else { SDL_SetRenderDrawColor(mRenderer, 0, 0, 0, SDL_ALPHA_OPAQUE); }

    SDL_RenderDrawRect(mRenderer, &frameRectangle);
    SDL_RenderDrawRect(mRenderer, &frameRectangleInner);
  }
  DSPRenderText(screen_width,screen_height);
  DSPRenderImage(screen_width,screen_height);
 
  SDL_RenderPresent(mRenderer);
}

//-------------------------------------------------------------------------------------------------------
