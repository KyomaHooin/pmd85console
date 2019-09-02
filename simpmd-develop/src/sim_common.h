/*

SIM_COMMON.H

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

#include <assert.h>
#include <stdint.h>
#include <pthread.h>

#include <atomic>
#include <iomanip>
#include <iostream>

#include <boost/program_options.hpp>
namespace opt = boost::program_options;

#include <SDL2/SDL.h>


//--------------------------------------------------------------------------
// Types

typedef unsigned int    uint;

typedef uint8_t         byte;
typedef uint16_t        word;

typedef uint32_t        uint32;
typedef uint64_t        uint64;


//--------------------------------------------------------------------------
// Macros

/// Returns the smaller one of two arguments.
#define MIN(A,B) ((A) < (B) ? (A) : (B))
/// Returns the greater one of two arguments.
#define MAX(A,B) ((A) > (B) ? (A) : (B))

/// Returns the nearest higher power of two.
#define POT(X) ({ uint O = 1; uint H = (X); while (H > 1) { H >>= 1; O <<= 1; }; O; })


//--------------------------------------------------------------------------
// System Related Constants

/// Reasonable alignment to prevent cache line ping pong.
#define SAFE_ALIGNMENT          64


//--------------------------------------------------------------------------
// Simulator Related Constants

/// Simulated processor clock rate
#define PMD_CLOCK       (18432000 / 9)

/// Model PMD 85-1
#define PMD_MODEL_1     1
/// Model PMD 85-2
#define PMD_MODEL_2     2


//--------------------------------------------------------------------------
// Atomics

/// Atomic boolean wrapper with short syntax for relaxed ordering.
class relaxed_bool
{
  private:
    std::atomic<bool> bValue __attribute__ ((aligned (SAFE_ALIGNMENT)));
    bool bPadding __attribute__ ((aligned (SAFE_ALIGNMENT)));
  public:
    relaxed_bool (bool bInitial) : bValue (bInitial) { }
    inline operator bool () { return (bValue.load (std::memory_order_relaxed)); }
    inline void operator = (bool bAssignment) { bValue.store (bAssignment, std::memory_order_relaxed); }
};

/// Atomic integer wrapper with short syntax for relaxed ordering.
class relaxed_int
{
  private:
    std::atomic<int> iValue __attribute__ ((aligned (SAFE_ALIGNMENT)));
    int iPadding __attribute__ ((aligned (SAFE_ALIGNMENT)));
  public:
    relaxed_int (int iInitial) : iValue (iInitial) { }
    inline operator int () { return (iValue.load (std::memory_order_relaxed)); }
    inline void operator = (int iAssignment) { iValue.store (iAssignment, std::memory_order_relaxed); }
    inline void operator += (int iIncrement) { iValue.fetch_add (iIncrement, std::memory_order_relaxed); }
    inline void operator -= (int iDecrement) { iValue.fetch_sub (iDecrement, std::memory_order_relaxed); }
};


//--------------------------------------------------------------------------
// Globals

// To be entirely correct, we should use atomic bytes for memory arrays.
// This would likely be much syntactic work with little semantic impact.

extern byte abMemoryData [65536];
extern bool abMemoryMask [65536];

extern relaxed_int iProcessorClock;


//--------------------------------------------------------------------------
// Externals

void SIMRequestShutdown ();
bool SIMQueryShutdown ();

void CONStartThread ();
void CONTerminateThread ();
void CONInitialize ();
void CONShutdown ();

void CPUReset ();
void CPUStartThread ();
void CPUTerminateThread ();
void CPUInitialize ();
void CPUShutdown ();

void DSPPaintHandler ();
void DSPResizeHandler ();
opt::options_description &DSPOptions ();
void DSPInitialize ();
void DSPShutdown ();

byte KBDReadRow ();
byte KBDReadColumn ();
void KBDWriteColumn (byte iData);
void KBDEventHandler (const SDL_KeyboardEvent *);
void KBDInitialize ();
void KBDShutdown ();

void SNDSynchronize ();
void SNDWriteSpeaker (byte iData);
opt::options_description &SNDOptions ();
void SNDInitialize ();
void SNDShutdown ();

byte TAPReadData ();
void TAPWriteData (byte iData);
byte TAPReadStatus ();
opt::options_description &TAPOptions ();
void TAPInitialize ();
void TAPShutdown ();

void TIMSynchronize ();
void TIMAdvance ();
opt::options_description &TIMOptions ();
void TIMInitialize ();
void TIMShutdown ();


//--------------------------------------------------------------------------
// Debugging

/// Displays a message with a terminating newline.
#define DEBUG_LOG(X) std::cout << X << std::endl
/// Displays a message without a terminating newline.
#define DEBUG_LOG_PARTIAL(X) std::cout << X
/// Displays the terminating newline.
#define DEBUG_LOG_NEWLINE std::cout << std::endl

/// Display instructions while executing.
#undef DEBUG_CPU_TRACE_INSTRUCTIONS
/// Display registers while executing.
#undef DEBUG_CPU_TRACE_REGISTERS

/// Executes a function and makes sure it returned 0.
#define CheckZero(X) if (X) { assert (false); }
/// Executes an SDL function and makes sure it returned 0.
#define SDL_CheckZero(X) if (X) { DEBUG_LOG (SDL_GetError ()); assert (false); }
/// Executes an SDL function and makes sure it returned TRUE.
#define SDL_CheckTrue(X) if (!X) { DEBUG_LOG (SDL_GetError ()); assert (false); }
/// Executes an SDL function and makes sure it did not return NULL.
#define SDL_CheckNotNull(X) if ((X) == NULL) { DEBUG_LOG (SDL_GetError ()); assert (false); }

//--------------------------------------------------------------------------
