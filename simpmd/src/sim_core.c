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

/* MODIFIED

 -Added:
 
 static void FlushMemory (int iFrom, int iSize)
 static void EmulationInitialize (int gameIndex)
 static void EmulationShutdown ()

 -Heavily modified main loop.

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
static std::string gameSelect[4] = {
  "/root/simpmd/data/tapes/games-pmd1/FLAPPY",
  "/root/simpmd/data/tapes/games-pmd1/BOULDER",
  "/root/simpmd/data/tapes/games-pmd1/MANIC+",
  "/root/simpmd/data/tapes/games-pmd2/FRED"
};

/// Game Tape IN
std::vector <std::string> gameIn;
/// Screen resolution
SDL_DisplayMode fullscreen;
/// Menu
bool inMenu = true;
/// Game Index
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


/** Flush memory.
 *
 *  @arg iFrom From which address.
 *  @arg iSize How large block.
 */
static void FlushMemory (int iFrom, int iSize)
{
  for (int iAddr = iFrom ; iAddr < iFrom + iSize ; iAddr ++)
  {
    abMemoryData [iAddr] = 0;
  }
}


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
static void EmulationInitialize (int gameIndex){
  // Flush garbage
  FlushMemory(0x0000, 65536);
  // Reset processor clock
  iProcessorClock = 0;
  // Set Tape
  gameIn.clear();
  gameIn.push_back(gameSelect[gameIndex]);
  TAPNextInputFile(gameIn);

  InitializePMD1();
  printf("Model initializing..\n");
  CPUInitialize ();
  printf("CPU initializing..\n");
  DSPInitialize();
  printf("DSP initializing..\n");
  KBDInitialize ();
  printf("KBD initializing..\n");
  //SNDInitialize ();
  //printf("SND initializing..\n");
  TAPInitialize ();
  printf("Tape initializing..\n");
 
  CPUStartThread ();
  printf("CPU Thread initializing..\n");
}


/// Shutdown emulation
static void EmulationShutdown (){
  CPUTerminateThread ();
  printf("CPU Thread shutdown..\n");

  TAPShutdown ();
  printf("TAP shutdown..\n");
  //SNDShutdown ();
  //printf("SND shutdown..\n");
  KBDShutdown ();
  printf("KBD shutdown..\n");
  DSPShutdown();
  printf("DSP shutdown..\n");
  CPUShutdown ();
  printf("CPU shutdown..\n");
}


//--------------------------------------------------------------------------
// Main

int main (int iArgC, const char *apArgV [])
{

  // SDL Init
  SDL_CheckZero (SDL_Init (SDL_INIT_AUDIO | SDL_INIT_TIMER | SDL_INIT_VIDEO));
  printf("SDL Initializing..\n");
  //Disable cursor
  SDL_ShowCursor (0);
  // Get fullscreen resolution
  SDL_CheckZero (SDL_GetCurrentDisplayMode(0, &fullscreen));
  //Logo
  DSPLogoInitialize ();
  DSPRenderLogo (fullscreen.w, fullscreen.h);
  DSPLogoShutdown ();
  // Menu
  DSPMenuInitialize ();
  DSPRenderMenu (fullscreen.w, fullscreen.h, gameIndex);
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
               DSPRenderMenu (fullscreen.w, fullscreen.h, gameIndex);
             }
             if (sEvent.key.keysym.sym == SDLK_RIGHT) { 
               (gameIndex == 3) ? gameIndex = 0 : gameIndex++;
               DSPRenderMenu (fullscreen.w, fullscreen.h, gameIndex);
             }
             if (sEvent.key.keysym.sym == SDLK_RETURN) {
               DSPMenuShutdown ();
               EmulationInitialize (gameIndex);
               inMenu = false;	
             }
           }
        } else {
          if (sEvent.key.keysym.sym == SDLK_ESCAPE) {
            EmulationShutdown ();
            DSPMenuInitialize ();
            DSPRenderMenu (fullscreen.w, fullscreen.h, gameIndex);
            inMenu = true;
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

  // Menu shutdown
  DSPMenuShutdown ();
  // Quit
  SDL_Quit ();

  return (0);
}


//--------------------------------------------------------------------------

