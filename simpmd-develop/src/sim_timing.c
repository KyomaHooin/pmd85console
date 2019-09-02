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

#include "sim_common.h"

#include <time.h>


//--------------------------------------------------------------------------
// Command Line Options

/// Timing precision. How many simulated clock ticks pass before synchronizing with actual time.
static int iArgPrecision = PMD_CLOCK / 1000;


//--------------------------------------------------------------------------
// Data

/// Last synchronized value of actual time
static struct timespec sLastTime;
/// Last synchronized value of simulated clock
static int iLastClock;


//--------------------------------------------------------------------------
// Timing

/// Synchronizes simulated clock with real time.
void TIMSynchronize ()
{
  clock_gettime (CLOCK_MONOTONIC, &sLastTime);
  iLastClock = iProcessorClock;
}


/** Advances real time to match simulated time by sleeping.
 *
 */
void TIMAdvance ()
{
  // Only synchronize when enough simulated clock ticks have passed.
  int iDelta = iProcessorClock - iLastClock;
  if (__builtin_expect ((iDelta >= iArgPrecision) && (iArgPrecision > 0), false))
  {
    // Convert the simulated clock delta into the real time delta.
    uint64 iSleep = iDelta;
    iSleep *= 1000000000;
    iSleep /= PMD_CLOCK;

    // Convert the real time delta into the time value required
    // for the sleep function and sleep until that time is reached.
    uint64 iNanos = sLastTime.tv_nsec + iSleep;
    sLastTime.tv_nsec = iNanos % 1000000000;
    sLastTime.tv_sec += iNanos / 1000000000;
    clock_nanosleep (CLOCK_MONOTONIC, TIMER_ABSTIME, &sLastTime, NULL);

    // Update the last simulated clock.
    iLastClock = iProcessorClock;
  }
}


//--------------------------------------------------------------------------
// Sleeping

/** Waits given number of ticks of simulated clock.
 *
 * We do not want to add overhead by having simulator signal us.
 * We therefore estimate the real time and then wait normally.
 */
void TIMSleep (int iTicks)
{
  // Calculate the simulated time when the wait should finish.
  int iExpectedClock = iProcessorClock + iTicks;

  while (true)
  {
    // See how long a wait remains in simulated clock.
    // Leave the cycle if we have waited long enough.
    int iDelta = iExpectedClock - iProcessorClock;
    if (iDelta <= 0) break;

    // Convert the simulated clock delta into the real time delta.
    uint64 iSleep = iDelta;
    iSleep *= 1000000000;
    iSleep /= PMD_CLOCK;

    // Wait that real time delta and then see again how much time expired.
    struct timespec sSleep;
    sSleep.tv_nsec = iSleep % 1000000000;
    sSleep.tv_sec += iSleep / 1000000000;
    clock_nanosleep (CLOCK_MONOTONIC, 0, &sSleep, NULL);
  }
}


//--------------------------------------------------------------------------
// Initialization and shutdown

opt::options_description &TIMOptions ()
{
  static opt::options_description options ("Timing module options");
  options.add_options ()
    ("precision", opt::value<int> (&iArgPrecision), "Clock synchronization period, 0 for no synchronization [ticks]");
  return (options);
}


void TIMInitialize ()
{
  // Nothing really ...
}


void TIMShutdown ()
{
  // Nothing really ...
}


//--------------------------------------------------------------------------

