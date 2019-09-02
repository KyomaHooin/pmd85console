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

#include "sim_common.h"

#include <string>
#include <vector>
#include <fstream>


//--------------------------------------------------------------------------
// Command Line Options

/// Tape input names. What files to open as tape inputs.
static std::vector <std::string> oArgTapeInputs;
/// Tape output names. What files to open as tape outputs.
static std::vector <std::string> oArgTapeOutputs;

/// Time tape input. Whether to simulate timing of the tape input.
static bool bArgTimeTapeInput = false;
/// Time tape output. Whether to simulate timing of the tape output.
static bool bArgTimeTapeOutput = false;

/// Tape rate. What tape rate to assume when simulating timing.
static int iArgTapeRate = 2400;


//--------------------------------------------------------------------------
// Data

/// Number of bits in byte on tape.
#define PMD_TAP_BITS    10

/// Mask for status TxRDY bit.
#define PMD_TAP_TXRDY_MASK        (1 << 0)
/// Mask for status RxRDY bit.
#define PMD_TAP_RXRDY_MASK        (1 << 1)

/// Tape input file stream.
static std::ifstream oTapeInput;
/// Tape output file stream.
static std::ofstream oTapeOutput;

/// Last value of simulated clock at input.
static int iLastInputClock;
/// Last value of simulated clock at output.
static int iLastOutputClock;


//--------------------------------------------------------------------------
// File operations

/** Advance to next file.
 *
 * @arg oStream Stream to advance.
 * @arg oNames Names list to use.
 * @return Indicates whether there was a next file.
 */
template <class tStream> bool TAPNextFile (tStream &oStream, std::vector <std::string> &oNames)
{
  // Close current file if any.
  if (oStream.is_open ()) oStream.close ();

  // Open next file if any.
  if (oNames.empty ()) return (false);

  oStream.clear ();
  oStream.open (oNames.front ());
  oNames.erase (oNames.begin ());

  return (true);
}

bool TAPNextInputFile  () { return (TAPNextFile <std::ifstream> (oTapeInput, oArgTapeInputs)); }
bool TAPNextOutputFile () { return (TAPNextFile <std::ofstream> (oTapeOutput, oArgTapeOutputs)); }


/** Check input file status.
 *
 * Advances to next input file as necessary.
 *
 * @return Indicates readiness of tape input file.
 */
bool TAPInputFileStatus ()
{
  // We need to peek to know if there will be data.
  // Stream end of file flag is set only on access.
  while (true)
  {
    if (oTapeInput.peek () != EOF) return (true);
    if (!TAPNextInputFile ()) return (false);
  }
}


/** Check output file status.
 *
 * Advances to next output file as necessary.
 *
 * @return Indicates readiness of tape output file.
 */
bool TAPOutputFileStatus ()
{
  // Suffering senseless symmetry :-) ...
  while (true)
  {
    if (oTapeOutput.good ()) return (true);
    if (!TAPNextOutputFile ()) return (false);
  }
}


//--------------------------------------------------------------------------
// Serial operations

/** Check if we should indicate RxRDY.
 */
bool TAPStatusRxRDY ()
{
  if (bArgTimeTapeInput)
  {
    // If the tape input timing is to be simulated,
    // data reads have certain speed.

    int iTimeDelta = iProcessorClock - iLastInputClock;
    int iCharDelta = PMD_TAP_BITS * PMD_CLOCK / iArgTapeRate;

    if (iTimeDelta < iCharDelta) return (false);
  }

  // If timing is fine return input stream status.
  return (TAPInputFileStatus ());
}


/** Check if we should indicate TxRDY.
 */
bool TAPStatusTxRDY ()
{
  if (bArgTimeTapeOutput)
  {
    // If the tape output timing is to be simulated,
    // data writes have certain speed.

    int iTimeDelta = iProcessorClock - iLastOutputClock;
    int iCharDelta = PMD_TAP_BITS * PMD_CLOCK / iArgTapeRate;

    if (iTimeDelta < iCharDelta) return (false);
  }

  // If timing is fine return output stream status.
  return (TAPOutputFileStatus ());
}


//--------------------------------------------------------------------------
// Port operations

/** Read from tape data register.
 */
byte TAPReadData ()
{
  if (TAPStatusRxRDY ())
  {
    iLastInputClock = iProcessorClock;
    return (oTapeInput.get ());
  }
  return (0);
}


/** Write to tape data register.
 *
 *  @arg iData The written value.
 */
void TAPWriteData (byte bData)
{
  if (TAPStatusTxRDY ())
  {
    iLastOutputClock = iProcessorClock;
    oTapeOutput.put (bData);
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

opt::options_description &TAPOptions ()
{
  static opt::options_description options ("Tape module options");
  options.add_options ()
    ("tape-in,i", opt::value <std::vector <std::string>> (&oArgTapeInputs), "Files to open as tape inputs")
    ("tape-out,o", opt::value <std::vector <std::string>> (&oArgTapeOutputs), "Files to open as tape outputs")
    ("time-tape-input", opt::value <bool> (&bArgTimeTapeInput), "Simulate tape input timing")
    ("time-tape-output", opt::value <bool> (&bArgTimeTapeOutput), "Simulate tape output timing")
    ("tape-rate", opt::value <int> (&iArgTapeRate), "Tape rate [bps]");
  return (options);
}


void TAPInitialize ()
{
  // Nothing really ...
}


void TAPShutdown ()
{
  // Close tape input and tape output.
  if (oTapeInput.is_open ())  oTapeInput.close ();
  if (oTapeOutput.is_open ()) oTapeOutput.close ();
}


//--------------------------------------------------------------------------

