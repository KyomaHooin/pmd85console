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

#include <popt.h>
#include <assert.h>
#include <stdint.h>

#include <iostream>

#include <SDL/SDL.h>

#include "sim_common.h"


//--------------------------------------------------------------------------
// Command Line Options

/// Screen refresh. How many milliseconds per screen refresh.
static int iArgRefresh = 20;

/// Initial screen zoom.
static int iArgZoom = 3;

/// Module command line options table.
struct poptOption asDSPOptions [] =
{
  { "zoom", 'z', POPT_ARG_INT | POPT_ARGFLAG_SHOW_DEFAULT,
      &iArgZoom, 0,
      "Initial screen zoom", NULL },
  { "refresh", 0, POPT_ARG_INT | POPT_ARGFLAG_SHOW_DEFAULT,
      &iArgRefresh, 0,
      "Screen refresh period", "ms" },
  POPT_TABLEEND
};


//--------------------------------------------------------------------------
// Data

/// Singleton screen surface.
static SDL_Surface *pScreen;

/// Paint timer
static SDL_TimerID iPaintTimer;


static SDL_Color sColorBlack = {   0,   0,   0 };
static SDL_Color sColorWhite = { 255, 255, 255 };
static SDL_Color sColorGray  = { 192, 192, 192 };

#define DSP_COLOR_BLACK         0
#define DSP_COLOR_WHITE         1
#define DSP_COLOR_GRAY          2


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


//--------------------------------------------------------------------------
// Screen size

/** Size the screen.
 *
 *  Performs the necessary video mode initialization.
 *
 *  @arg iWidth Proposed screen width.
 *  @arg iHeight Proposed screen height.
 */
void DSPSizeScreen (int iWidth, int iHeight)
{
  // Any width and height is multiple of standard width and height.
  int iStandardWidth = PMD_VRAM_WIDTH * PMD_PIXEL_COUNT;
  int iStandardHeight = PMD_VRAM_HEIGHT;
  // Calculate the rounded width and height.
  int iRealWidth = iWidth - iWidth % iStandardWidth;
  int iRealHeight = iHeight - iHeight % iStandardHeight;
  // Minimum width and height.
  iRealWidth = MAX (iRealWidth, iStandardWidth);
  iRealHeight = MAX (iRealHeight, iStandardHeight);

  // Create the surface to draw upon ...
  SDL_CheckNotNull (pScreen = SDL_SetVideoMode (iRealWidth, iRealHeight, 8, SDL_HWSURFACE | SDL_DOUBLEBUF | SDL_RESIZABLE));

  // Create a palette with the required colors ...
  SDL_SetColors (pScreen, &sColorBlack, DSP_COLOR_BLACK, 1);
  SDL_SetColors (pScreen, &sColorWhite, DSP_COLOR_WHITE, 1);
  SDL_SetColors (pScreen, &sColorGray,  DSP_COLOR_GRAY,  1);
}


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
 *  direct writing to screen buffer. Optimized for 1:1 zoom.
 */
void DSPDecodeScreen ()
{
  bool bBlinkVisible = DSPBlinkVisible ();

  // Traverse the memory content line by line and byte by byte
  // and paint the screen content as we go.
  byte *pSource = & MemData [PMD_VRAM_BASE];
  byte *pTarget = (byte *) pScreen->pixels;
  for (int iLine = 0 ; iLine < PMD_VRAM_HEIGHT ; iLine ++)
  {
    for (int iByte = 0 ; iByte < PMD_VRAM_WIDTH ; iByte ++)
    {
      byte iData = *pSource;

      // Determine the drawing color. All pixels in one byte share color
      byte iColor = (iData & PMD_PIXEL_GRAY) ? iColor = DSP_COLOR_GRAY
                                             : iColor = DSP_COLOR_WHITE;
      if ((iData & PMD_PIXEL_BLINK) && !bBlinkVisible) iColor = DSP_COLOR_BLACK;

      // The inner cycle is unrolled for speed

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

    pTarget += pScreen->pitch - PMD_VRAM_WIDTH * PMD_PIXEL_COUNT;
    pSource += PMD_VRAM_BLANK;
  }
}


/** Decode the screen content in 1:X and 1:Y zoom.
 *
 *  Decodes the memory content of the simulated machine using
 *  direct writing to screen buffer. Generalized for any zoom.
 *
 *  @arg iZoomWidth Multiple of standard width.
 *  @arg iZoomHeight Multiple of standard height.
 */
void DSPDecodeScreenWithZoom (int iZoomWidth, int iZoomHeight)
{
  bool bBlinkVisible = DSPBlinkVisible ();

  // Traverse the memory content line by line and byte by byte
  // and paint the screen content as we go. Repeat each step
  // as many times as directed by the zoom level.
  byte *pSourceBase = & MemData [PMD_VRAM_BASE];
  byte *pTargetBase = (byte *) pScreen->pixels;
  for (int iLine = 0 ; iLine < PMD_VRAM_HEIGHT ; iLine ++)
  {
    for (int iLineZoom = 0 ; iLineZoom < iZoomHeight ; iLineZoom ++)
    {
      byte *pSourceData = pSourceBase;
      byte *pTargetData = pTargetBase;

      for (int iByte = 0 ; iByte < PMD_VRAM_WIDTH ; iByte ++)
      {
        byte iData = *pSourceData;

        // Determine the drawing color. All pixels in one byte share color
        byte iColor = (iData & PMD_PIXEL_GRAY) ? iColor = DSP_COLOR_GRAY
                                               : iColor = DSP_COLOR_WHITE;
        if ((iData & PMD_PIXEL_BLINK) && !bBlinkVisible) iColor = DSP_COLOR_BLACK;

        for (int iPixel = 0 ; iPixel < PMD_PIXEL_COUNT ; iPixel ++)
        {
          for (int iPixelZoom = 0 ; iPixelZoom < iZoomWidth ; iPixelZoom ++)
          {
            *pTargetData = (iData & 1) ? iColor : DSP_COLOR_BLACK;
            pTargetData ++;
          }
          iData >>= 1;
        }

        pSourceData ++;
      }

      pTargetBase += pScreen->pitch;
    }

    pSourceBase += PMD_VRAM_WIDTH + PMD_VRAM_BLANK;
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
  SDL_LockSurface (pScreen);

  // Decide which decoder to use based on the screen size.
  // We have a decoder for the standard screen size and
  // a decoder for an arbitrary screen size.

  int iZoomWidth = pScreen->w / (PMD_VRAM_WIDTH * PMD_PIXEL_COUNT);
  int iZoomHeight = pScreen->h / (PMD_VRAM_HEIGHT);

  if ((iZoomWidth == 1) && (iZoomHeight == 1))
  {
    DSPDecodeScreen ();
  }
  else
  {
    DSPDecodeScreenWithZoom (iZoomWidth, iZoomHeight);
  }

  SDL_UnlockSurface (pScreen);

  // Make the content visible
  SDL_Flip (pScreen);
}


/** Handler for resizing the screen content.
 *
 *  Reacts to the screen resize event. Constraints the
 *  available sizes to multiples of standard screen.
 *
 *  @arg pEvent The event to handle.
 */
void DSPResizeHandler (const SDL_ResizeEvent *pEvent)
{
  DSPSizeScreen (pEvent->w, pEvent->h);
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
  SDL_WM_SetCaption ("SimPMD", "SimPMD");

  // Size the screen ...
  DSPSizeScreen (iArgZoom * PMD_VRAM_WIDTH * PMD_PIXEL_COUNT,
                 iArgZoom * PMD_VRAM_HEIGHT);

  // Start the timer that paints the screen repeatedly ...
  iPaintTimer = SDL_AddTimer (iArgRefresh, DSPPaintTimerCallback, NULL);
}


void DSPShutdown ()
{
  // Stop the timer that paints the screen repeatedly ...
  SDL_RemoveTimer (iPaintTimer);
}


//--------------------------------------------------------------------------

