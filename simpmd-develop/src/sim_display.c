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


//--------------------------------------------------------------------------
// Command Line Options

/// Screen refresh. How many milliseconds per screen refresh.
static int iArgRefresh = 20;

/// Initial screen zoom.
static int iArgZoom = 3;


//--------------------------------------------------------------------------
// Data

/// Singleton screen window.
static SDL_Window *pWindow;
/// Singleton screen renderer;
static SDL_Renderer *pRenderer;
/// Singleton screen texture;
static SDL_Texture *pTexture;

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

opt::options_description &DSPOptions ()
{
  static opt::options_description options ("Display module options");
  options.add_options ()
    ("zoom,z", opt::value<int> (&iArgZoom), "Initial screen zoom")
    ("refresh", opt::value<int> (&iArgRefresh), "Screen refresh period [ms]");
  return (options);
}


void DSPInitialize ()
{
  // Initialize the video resources.
  // Drawing is done by updating texture.
  SDL_CheckNotNull (pWindow = SDL_CreateWindow (
    "SimPMD",
    SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
    PMD_VRAM_WIDTH * PMD_PIXEL_COUNT, PMD_VRAM_HEIGHT,
    SDL_WINDOW_RESIZABLE));
  SDL_CheckNotNull (pRenderer = SDL_CreateRenderer (
    pWindow,
    -1, 0));
  SDL_CheckNotNull (pTexture = SDL_CreateTexture (
    pRenderer,
    SDL_PIXELFORMAT_RGB332,
    SDL_TEXTUREACCESS_STREAMING,
    PMD_VRAM_WIDTH * PMD_PIXEL_COUNT, PMD_VRAM_HEIGHT));
  SDL_CheckTrue (SDL_SetHint (
    SDL_HINT_RENDER_SCALE_QUALITY, "best"));

  // Clear screen.
  SDL_CheckZero (SDL_SetRenderDrawColor (pRenderer, 0, 0, 0, SDL_ALPHA_OPAQUE));
  SDL_CheckZero (SDL_RenderClear (pRenderer));
  SDL_RenderPresent (pRenderer);

  // Start the timer that paints the screen repeatedly ...
  iPaintTimer = SDL_AddTimer (iArgRefresh, DSPPaintTimerCallback, NULL);
}


void DSPShutdown ()
{
  // Stop the timer that paints the screen repeatedly ...
  SDL_RemoveTimer (iPaintTimer);

  SDL_DestroyTexture (pTexture);
  SDL_DestroyRenderer (pRenderer);
  SDL_DestroyWindow (pWindow);
}


//--------------------------------------------------------------------------

