/*

SIM_TAPE.C

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
#include <stdint.h>
#include <unistd.h>
#include <sys/types.h>

#include <SDL/SDL.h>

#include "sim_common.h"


//--------------------------------------------------------------------------
// Command Line Options

/// Tape input. What file to open as tape input.
static char *pArgTapeInput = NULL;
/// Tape output. What file to open as tape output.
static char *pArgTapeOutput = NULL;

/// Time tape input. Whether to simulate timing of the tape input.
static int iArgTimeTapeInput = false;
/// Time tape output. Whether to simulate timing of the tape output.
static int iArgTimeTapeOutput = false;

/// Tape rate. What tape rate to assume when simulating timing.
static int iArgTapeRate = 2400;

/// Module command line options table.
struct poptOption asTAPOptions [] =
{
  { "tape-in", 'i', POPT_ARG_STRING,
      &pArgTapeInput, 0,
      "File to open as tape input", "file" },
  { "tape-out", 'o', POPT_ARG_STRING,
      &pArgTapeOutput, 0,
      "File to open as tape output", "file" },
  { "time-tape-input", 0, POPT_ARG_VAL,
      &iArgTimeTapeInput, true,
      "Simulate tape input timing", NULL },
  { "time-tape-output", 0, POPT_ARG_VAL,
      &iArgTimeTapeOutput, true,
      "Simulate tape output timing", NULL },
  { "tape-rate", 0, POPT_ARG_INT | POPT_ARGFLAG_SHOW_DEFAULT,
      &iArgTapeRate, 0,
      "Tape rate", "bps" },
  POPT_TABLEEND
};


//--------------------------------------------------------------------------
// Data

/// Number of bits in byte on tape.
#define PMD_TAP_BITS    10

/// Mask for status TxRDY bit.
#define PMD_TAP_TXRDY_MASK        (1 << 0)
/// Mask for status RxRDY bit.
#define PMD_TAP_RXRDY_MASK        (1 << 1)

/// Tape input file handle.
static int hTapeInput = INVALID_HANDLE;
/// Tape output file handle.
static int hTapeOutput = INVALID_HANDLE;

/// Last value of simulated clock at input.
static int iLastInputClock;
/// Last value of simulated clock at output.
static int iLastOutputClock;


//--------------------------------------------------------------------------
// Serial operations

/** Check if we should indicate RxRDY.
 */
bool TAPStatusRxRDY ()
{
  if (iArgTimeTapeInput)
  {
    // If the tape input timing is to be simulated,
    // data reads have certain speed.

    int iTimeDelta = Clock - iLastInputClock;
    int iCharDelta = PMD_TAP_BITS * PMD_CLOCK / iArgTapeRate;

    if (iTimeDelta < iCharDelta) return (false);
  }

  // The input stream must be valid.
  if (hTapeInput == INVALID_HANDLE) return (false);

  return (true);
}


/** Check if we should indicate TxRDY.
 */
bool TAPStatusTxRDY ()
{
  if (iArgTimeTapeOutput)
  {
    // If the tape output timing is to be simulated,
    // data writes have certain speed.

    int iTimeDelta = Clock - iLastOutputClock;
    int iCharDelta = PMD_TAP_BITS * PMD_CLOCK / iArgTapeRate;

    if (iTimeDelta < iCharDelta) return (false);
  }

  // The output stream must be valid.
  if (hTapeOutput == INVALID_HANDLE) return (false);

  return (true);
}


//--------------------------------------------------------------------------
// Port operations

/** Read from tape data register.
 */
byte TAPReadData ()
{
  byte iData = 0;
  if (TAPStatusRxRDY)
  {
    read (hTapeInput, &iData, 1);
    iLastInputClock = Clock;
  }

  return (iData);
}


/** Write to tape data register.
 *
 *  @arg iData The written value.
 */
void TAPWriteData (byte iData)
{
  if (TAPStatusTxRDY)
  {
    write (hTapeOutput, &iData, 1);
    iLastOutputClock = Clock;
  }
}


/** Read from tape status register.
 */
byte TAPReadStatus ()
{
  return (TAPStatusTxRDY () * PMD_TAP_TXRDY_MASK |
          TAPStatusRxRDY () * PMD_TAP_RXRDY_MASK);
}


//--------------------------------------------------------------------------
// Initialization and shutdown

void TAPInitialize ()
{
  // If tape input or tape output was specified, open it.
  if (pArgTapeInput)  hTapeInput  = open (pArgTapeInput, O_RDONLY);
  if (pArgTapeOutput) hTapeOutput = open (pArgTapeOutput, O_WRONLY);
}


void TAPShutdown ()
{
  // Close tape input and tape output.
  if (hTapeInput  != INVALID_HANDLE) close (hTapeInput);
  if (hTapeOutput != INVALID_HANDLE) close (hTapeOutput);
}


//--------------------------------------------------------------------------

