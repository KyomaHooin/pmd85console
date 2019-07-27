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

#include <popt.h>
#include <fcntl.h>
#include <assert.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/types.h>

#include <iostream>

#include <SDL/SDL.h>
#include <SDL/SDL_thread.h>

#include "sim_common.h"


//--------------------------------------------------------------------------
// Command Line Options

/// Model to simulate.
int iArgModel = PMD_MODEL_1;

/// Core command line options table.
struct poptOption asOptions [] =
{
  // Core options.
  { "pmd1", '1', POPT_ARG_VAL,
      &iArgModel, PMD_MODEL_1,
      "Simulate PMD 85-1", NULL },
  { "pmd2", '2', POPT_ARG_VAL,
      &iArgModel, PMD_MODEL_2,
      "Simulate PMD 85-2", NULL },
  // Module options.
  { NULL, 0, POPT_ARG_INCLUDE_TABLE,
      &asDSPOptions, 0,
      "Display module options:", NULL },
  { NULL, 0, POPT_ARG_INCLUDE_TABLE,
      &asSNDOptions, 0,
      "Sound module options:", NULL },
  { NULL, 0, POPT_ARG_INCLUDE_TABLE,
      &asTAPOptions, 0,
      "Tape module options:", NULL },
  { NULL, 0, POPT_ARG_INCLUDE_TABLE,
      &asTIMOptions, 0,
      "Timing module options:", NULL },
  // Closing.
  POPT_AUTOHELP POPT_TABLEEND
};


//--------------------------------------------------------------------------
// System Status Variables

/// Simulated memory array.
byte MemData [65536];
/// Distinguishes readable and writable memory.
bool MemMask [65536];


//--------------------------------------------------------------------------
// Model Initialization

/** Mark a memory area as read write.
 *
 *  @arg iFrom From which address.
 *  @arg iSize How large block.
 */
void SetMemoryReadWrite (int iFrom, int iSize)
{
  for (int iAddr = iFrom ; iAddr < iFrom + iSize ; iAddr ++)
  {
    MemMask [iAddr] = true;
  }
}

/** Mark a memory area as read only.
 *
 *  @arg iFrom From which address.
 *  @arg iSize How large block.
 */
void SetMemoryReadOnly (int iFrom, int iSize)
{
  for (int iAddr = iFrom ; iAddr < iFrom + iSize ; iAddr ++)
  {
    MemMask [iAddr] = false;
  }
}

/** Fill a memory area with content from file.
 *
 *  @arg iFrom From which address.
 *  @arg iSize How large block.
 *  @arg pFile What file.
 */
void FillMemoryFromFile (int iFrom, int iSize, const char *pFile)
{
  int hFile = open (pFile, O_RDONLY);
  assert (hFile >= 0);
  int iRead = read (hFile, MemData + iFrom, iSize);
  assert (iRead == iSize);
  close (hFile);
}

/// Initialize a PMD 85-1 model.
void InitializePMD1 ()
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
void InitializePMD2 ()
{
  // Read the monitor image.
  FillMemoryFromFile (0x8000, 4096, PMD_SHARE "M2");
  // The entire 64k is read write.
  SetMemoryReadWrite (0x0000, 65536);
}


//--------------------------------------------------------------------------
// Main

int main (int iArgC, const char *apArgV [])
{
  // Command line option parsing

  poptContext pArgContext;

  pArgContext = poptGetContext (NULL, iArgC, apArgV, asOptions, 0);
  if (poptGetNextOpt (pArgContext) != POPT_NO_NEXT_OPT)
  {
    // Any option that is returned signals an error.
    poptPrintUsage (pArgContext, stderr, 0);
    return (1);
  }
  if (poptPeekArg (pArgContext) != NULL)
  {
    // Any argument that is left signals an error.
    poptPrintUsage (pArgContext, stderr, 0);
    return (1);
  }
  poptFreeContext (pArgContext);

  // Model initialization

  switch (iArgModel)
  {
    case PMD_MODEL_1: InitializePMD1 ();
                      break;
    case PMD_MODEL_2: InitializePMD2 ();
                      break;
    default:          assert (false);
  }

  // Module initialization

  SDL_CheckZero (SDL_Init (SDL_INIT_AUDIO | SDL_INIT_TIMER | SDL_INIT_VIDEO));

  CPUInitialize ();
  DSPInitialize ();
  KBDInitialize ();
  SNDInitialize ();
  TAPInitialize ();
  TIMInitialize ();

  SDL_Thread *pProcessor = SDL_CreateThread (CPUThread, NULL);

  // Event loop

  bool bQuit = false;
  SDL_Event sEvent;

  while (!bQuit)
  {
    SDL_WaitEvent (&sEvent);
    switch (sEvent.type)
    {
      case SDL_KEYUP:
      case SDL_KEYDOWN:
        KBDEventHandler ((SDL_KeyboardEvent *) &sEvent);
        break;
      case SDL_VIDEORESIZE:
        DSPResizeHandler ((SDL_ResizeEvent *) &sEvent);
        break;
      case SDL_USEREVENT:
        DSPPaintHandler ();
        break;
      case SDL_QUIT:
        bQuit = true;
        break;
    }
  }

  // Module shutdown

  TIMShutdown ();
  TAPShutdown ();
  SNDShutdown ();
  KBDShutdown ();
  DSPShutdown ();
  CPUShutdown ();

  SDL_Quit ();

  return (0);
}


//--------------------------------------------------------------------------

