/*

SIM_CONSOLE.C

Copyright 2010 Petr Tuma

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

#include <poll.h>
#include <signal.h>

#include <readline/history.h>
#include <readline/readline.h>

#include <string>


//--------------------------------------------------------------------------
// Synchronization Notes

// The console implementation executes in an independent thread. The simulator
// needs to initialize the module before starting the module thread and
// terminate the module thread before shutting down the module.
//
// CONInitialize - CONStartThread - CONTerminateThread - CONShutdown


//--------------------------------------------------------------------------
// Asynchronous Execution Variables

static pthread_t sThread;

// Synchronization variables ...

static relaxed_bool bTerminate (false);


//--------------------------------------------------------------------------
// Parser




//--------------------------------------------------------------------------
// Console

void CONLineCallback (char *pLine)
{
  // Detect end of input stream.
  if (pLine == NULL)
  {
    // End of input stream means shutdown.
    SIMRequestShutdown ();
  }
  else
  {
    if (strlen (pLine))
    {
      // Remember non empty lines in history.
      add_history (pLine);

//!@#@!
// See if this can be converted to reasonable strings.
//#@!@#

    }
  }

  // Prevent printing of an extra prompt when shutting down.
  if (SIMQueryShutdown ()) rl_set_prompt (NULL);
}


void *CONThread (void *pArgs)
{
  // The callback readline interface is used to avoid
  // issues with forcibly leaving the readline function.

  // Prepare the console for interactive mode.
  rl_callback_handler_install ("SimPMD> ", CONLineCallback);

  // Keep processing input characters until
  // poll is interrupted with a signal and
  // termination is requested.
  struct pollfd sConsoleDescriptor;
  sConsoleDescriptor.fd = STDIN_FILENO;
  sConsoleDescriptor.events = POLLIN | POLLPRI;
  while (!bTerminate)
  {
    if (poll (&sConsoleDescriptor, 1, -1) == 1)
    {
      rl_callback_read_char ();
    }
  }

  // Return the console to standard mode.
  rl_callback_handler_remove ();

  return (NULL);
}


//--------------------------------------------------------------------------
// Thread management

// Console code is one reason why POSIX threads are used instead of SDL threads.
// It is not possible to send signals to SDL threads using the standard interface.

void CONStartThread ()
{
  CheckZero (pthread_create (&sThread, NULL, CONThread, NULL));
}


void CONTerminateThread ()
{
  bTerminate = true;

  // Sent a signal to the thread to terminate.
  CheckZero (pthread_kill (sThread, SIGINT));

  // Just wait for the thread to terminate.
  CheckZero (pthread_join (sThread, NULL));
}


//--------------------------------------------------------------------------
// Initialization and shutdown

void CONInitialize ()
{
  // Nothing really ...
}


void CONShutdown ()
{
  // Nothing really ...
}


//--------------------------------------------------------------------------
