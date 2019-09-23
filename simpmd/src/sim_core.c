/*

SIM_CORE.C

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
#include <fstream>

//--------------------------------------------------------------------------
// System Status Variables

// If we were to be entirely correct, the memory arrays
// should be declared volatile. However, this just
// leads to more complex display code and is
// otherwise unlikely to change anything.

/// Simulated memory array.
byte abMemoryData [65536] __attribute__ ((aligned (SAFE_ALIGNMENT)));
/// Simulator memory mask.
/// Distinguishes readable and writable memory.
bool abMemoryMask [65536] __attribute__ ((aligned (SAFE_ALIGNMENT)));

/// Processor clock counter.
/// Note that access to clock is not ordered !!!
relaxed_int iProcessorClock (0);

/// Simulator shutdown flag.
static relaxed_bool bShutdown (false);

/// Predefined Games
static std::string GameSelect[4] = {
  "root/simpmd-develop/data/tapes/games-pmd1/FLAPPY",
  "root/simpmd-develop/data/tapes/games-pmd1/BOULDER",
  "root/simpmd-develop/data/tapes/games-pmd1/MANIC+",
  "root/simpmd-develop/data/tapes/games-pmd2/FRED"
};
// foo.clear();
// foo.push_back(GameSelect[0]);

//Screen resolution
SDL_DisplayMode fullscreen;
// Menu
bool inMenu = true;
// Game Index
int gameIndex = 0;

//--------------------------------------------------------------------------
// Simulator Control

/// Request simulator shutdown.
void SIMRequestShutdown ()
{
  // No active notification is needed since the main
  // event loop delivers messages periodically and
  // is therefore bound to observe the variable.

  bShutdown = true;
}


bool SIMQueryShutdown ()
{
  return (bShutdown);
}


//--------------------------------------------------------------------------
// Model Initialization

/** Mark a memory area as read write.
 *
 *  @arg iFrom From which address.
 *  @arg iSize How large block.
 */
static void SetMemoryReadWrite (int iFrom, int iSize)
{
  for (int iAddr = iFrom ; iAddr < iFrom + iSize ; iAddr ++)
  {
    abMemoryMask [iAddr] = true;
  }
}

/** Mark a memory area as read only.
 *
 *  @arg iFrom From which address.
 *  @arg iSize How large block.
 */
static void SetMemoryReadOnly (int iFrom, int iSize)
{
  for (int iAddr = iFrom ; iAddr < iFrom + iSize ; iAddr ++)
  {
    abMemoryMask [iAddr] = false;
  }
}


/** Fill a memory area with content from file.
 *
 *  @arg iFrom From which address.
 *  @arg iSize How large block.
 *  @arg pFile What file.
 */
static void FillMemoryFromFile (int iFrom, int iSize, const char *pFile)
{
  std::ifstream oFile;
  oFile.open (pFile);
  oFile.read (reinterpret_cast <char *> (abMemoryData + iFrom), iSize);
  oFile.close ();
  assert (oFile.good ());
}


/// Initialize a PMD 85-1 model.
static void InitializePMD1 ()
{
  // Read the monitor image.
  FillMemoryFromFile (0x8000, 4096, PMD_SHARE "M1");
  FillMemoryFromFile (0xA000, 4096, PMD_SHARE "M1");
  // The first 32k is read write.
  // The next 16k is read only.
  // The last 16k is read write.
  SetMemoryReadWrite (0x0000, 32768);
  SetMemoryReadOnly  (0x8000, 16384);
  SetMemoryReadWrite (0xC000, 16384);
}


/// Initialize a PMD 85-2 model.
static void InitializePMD2 ()
{
  // Read the monitor image.
  FillMemoryFromFile (0x8000, 4096, PMD_SHARE "M2");
  // The entire 64k is read write.
  SetMemoryReadWrite (0x0000, 65536);
}

/// Initialize emulation
static void InitializeEmulation (){
  CPUInitialize ();
  KBDInitialize ();
  //SNDInitialize ();
  TAPInitialize ();

  CPUStartThread ();
}

/// Shutdown emulation
static void ShutdownEmulation (){
  CPUTerminateThread ();

  TAPShutdown ();
  //SNDShutdown ();
  KBDShutdown ();
  CPUShutdown ();
}


//--------------------------------------------------------------------------
// Main

int main (int iArgC, const char *apArgV [])
{

  // SDL Init
  printf("SDL Initializing..\n");
  SDL_CheckZero (SDL_Init (SDL_INIT_AUDIO | SDL_INIT_TIMER | SDL_INIT_VIDEO));

  // Get fullscreen resolution
  SDL_CheckZero (SDL_GetCurrentDisplayMode(0,&fullscreen));

  // Display initialize
  //DSPInitialize ();

  //Menu initialize
  DSPMenuInitialize();
  DSPRenderMenu(fullscreen.w, fullscreen.h,gameIndex);

  // Event loop
  SDL_Event sEvent;

  while (!SIMQueryShutdown ())
  {
    SDL_WaitEvent (&sEvent);
    switch (sEvent.type)
    {
      case SDL_KEYUP:
      case SDL_KEYDOWN:
       if (inMenu) {
          if (sEvent.type == SDL_KEYDOWN) {
            if (sEvent.key.keysym.sym == SDLK_ESCAPE) { 
              SIMRequestShutdown ();
	    }
            if (sEvent.key.keysym.sym == SDLK_LEFT) {
              (gameIndex == 0) ? gameIndex = 3 : gameIndex--;
              DSPRenderMenu(fullscreen.w, fullscreen.h,gameIndex);
            }
            if (sEvent.key.keysym.sym == SDLK_RIGHT) { 
              (gameIndex == 3) ? gameIndex = 0 : gameIndex++;
              DSPRenderMenu(fullscreen.w, fullscreen.h,gameIndex);
            }
            if (sEvent.key.keysym.sym == SDLK_RETURN) {
              (gameIndex == 3) ? InitializePMD2() : InitializePMD1();// FRED => PMD2
              DSPMenuShutdown();
	      DSPInitialize();
              InitializeEmulation();
              inMenu = false;	
            }
          } 
        } else {
          if (sEvent.key.keysym.sym == SDLK_ESCAPE) {
            ShutdownEmulation();
	    DSPShutdown();
            inMenu = true;
            DSPMenuInitialize();
            DSPRenderMenu(fullscreen.w, fullscreen.h,gameIndex);
        } else {
            KBDEventHandler ((SDL_KeyboardEvent *) &sEvent);
          }
        }
        break;
      case SDL_USEREVENT:
        if (!inMenu) {
          DSPPaintHandler ();
        }
        break;
    }
  }

  //Menu shutdown
  DSPMenuShutdown ();

  SDL_Quit ();

  return (0);
}


//--------------------------------------------------------------------------

