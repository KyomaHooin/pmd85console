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
// Command Line Options

/// Model to simulate.
static bool bArgModelOne = false;
static bool bArgModelTwo = false;


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


//--------------------------------------------------------------------------
// Main

int main (int iArgC, const char *apArgV [])
{
  // Command line option parsing

  opt::options_description oFlagNames ("Core options");
  oFlagNames.add_options ()
    ("pmd1,1", opt::bool_switch (&bArgModelOne), "Simulate PMD 85-1")
    ("pmd2,2", opt::bool_switch (&bArgModelTwo), "Simulate PMD 85-2");
  oFlagNames.add (DSPOptions ());
  oFlagNames.add (SNDOptions ());
  oFlagNames.add (TAPOptions ());
  oFlagNames.add (TIMOptions ());

  opt::positional_options_description oFlagPositions;
  oFlagPositions.add ("script", 1);

  opt::variables_map oFlagVariables;
  opt::store (
    opt::command_line_parser (iArgC, apArgV).
    positional (oFlagPositions).
    options (oFlagNames).
    run (),
    oFlagVariables);
  opt::notify (oFlagVariables);

//!@#@!
if (bArgModelOne) InitializePMD1 ();
if (bArgModelTwo) InitializePMD2 ();
//#@!@#

//  {
//    // Any option that is returned signals an error.
//    poptPrintUsage (pArgContext, stderr, 0);
//    return (1);
//  }
//  if (poptPeekArg (pArgContext) != NULL)
//  {
//    // Any argument that is left signals an error.
//    poptPrintUsage (pArgContext, stderr, 0);
//    return (1);
//  }

  // Model initialization

//  switch (iArgModel)
//  {
//    case PMD_MODEL_1: InitializePMD1 ();
//                      break;
//    case PMD_MODEL_2: InitializePMD2 ();
//                      break;
//    default:          assert (false);
//  }

  // Module initialization

  SDL_CheckZero (SDL_Init (SDL_INIT_AUDIO | SDL_INIT_TIMER | SDL_INIT_VIDEO));

  CONInitialize ();
  CPUInitialize ();
  DSPInitialize ();
  KBDInitialize ();
  SNDInitialize ();
  TAPInitialize ();
  TIMInitialize ();

  // Console thread is the last to run because user commands require functional simulator.

  CPUStartThread ();
  CONStartThread ();

  // Event loop

  SDL_Event sEvent;

  while (!SIMQueryShutdown ())
  {
    SDL_WaitEvent (&sEvent);
    switch (sEvent.type)
    {
      case SDL_KEYUP:
      case SDL_KEYDOWN:
        KBDEventHandler ((SDL_KeyboardEvent *) &sEvent);
        break;
//      case SDL_WINDOWEVENT_RESIZED:
//        DSPResizeHandler ();
//        break;
      case SDL_USEREVENT:
        DSPPaintHandler ();
        break;
      case SDL_QUIT:
        SIMRequestShutdown ();
        break;
    }
  }

  // Console thread is the first to terminate because user commands require functional simulator.

  CONTerminateThread ();
  CPUTerminateThread ();

  // Module shutdown

  TIMShutdown ();
  TAPShutdown ();
  SNDShutdown ();
  KBDShutdown ();
  DSPShutdown ();
  CPUShutdown ();
  CONShutdown ();

  SDL_Quit ();

  return (0);
}


//--------------------------------------------------------------------------

