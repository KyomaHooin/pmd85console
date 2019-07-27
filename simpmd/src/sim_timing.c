/*

SIM_TIMING.C

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
#include <time.h>
#include <stdint.h>

#include <SDL/SDL.h>

#include "sim_common.h"


//--------------------------------------------------------------------------
// Command Line Options

/// Timing precision. How many simulated clock ticks pass before synchronizing with actual time.
static int iArgPrecision = PMD_CLOCK / 1000;

/// Module command line options table.
struct poptOption asTIMOptions [] =
{
  { "precision", 0, POPT_ARG_INT | POPT_ARGFLAG_SHOW_DEFAULT,
      &iArgPrecision, 0,
      "Clock synchronization period, 0 for no synchronization", "ticks" },
  POPT_TABLEEND
};


//--------------------------------------------------------------------------
// Data

/// Last synchronized value of actual time
static struct timespec sLastTime;
/// Last synchronized value of simulated clock
static int iLastClock;


//--------------------------------------------------------------------------
// Sleeping

/// Synchronizes simulated clock and actual time.
void TIMSynchronize ()
{
  clock_gettime (CLOCK_MONOTONIC, &sLastTime);
  iLastClock = Clock;
}


/// Advances simulated clock and actual time by sleeping.
void TIMAdvance (int iClock)
{
  // Only synchronize when enough simulated clock ticks have passed.
  int iDelta = iClock - iLastClock;
  if ((iDelta >= iArgPrecision) && (iArgPrecision > 0))
  {
    // Convert the simulated clock delta into the actual time delta
    uint64 iSleep = iDelta;
    iSleep *= 1000000000;
    iSleep /= PMD_CLOCK;

    // Convert the actual time delta into the actual time required
    // for the sleep function and sleep until that time is reached
    uint64 iNanos = sLastTime.tv_nsec + iSleep;
    sLastTime.tv_nsec = iNanos % 1000000000;
    sLastTime.tv_sec += iNanos / 1000000000;
    clock_nanosleep (CLOCK_MONOTONIC, TIMER_ABSTIME, &sLastTime, NULL);

    // Update the last simulated clock
    iLastClock = iClock;
  }
}


//--------------------------------------------------------------------------
// Initialization and shutdown

void TIMInitialize ()
{
  // Nothing really ...
}


void TIMShutdown ()
{
  // Nothing really ...
}


//--------------------------------------------------------------------------

