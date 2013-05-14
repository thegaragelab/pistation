/*--------------------------------------------------------------------------*
* Main program for the 'gpiokeys' daemon
*---------------------------------------------------------------------------*
* 07-May-2013 shaneg
*
* Initial version. This is very much a work in progress at this stage.
*--------------------------------------------------------------------------*/
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdarg.h>
#include <stdbool.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <syslog.h>
#include <string.h>
#include <wiringPi.h>

/*--------------------------------------------------------------------------*
* Constants and structures
*--------------------------------------------------------------------------*/

/** Default configuration file */
#define CONFIG_FILE "/etc/gpiokeys.cfg"

/** Maximum length of strings */
#define MAX_STRING 256

/** Maximum number of buttons */
#define MAX_BUTTONS 6

/** Map GPIO inputs to keyboard events
 */
static struct _GPIO_MAPPING {
  int  m_pin;   /** Pin number to monitor  */
  int  m_key;   /** Keyboard event to send */
  bool m_state; /** Last state             */
  } g_mapping[MAX_BUTTONS];

static int g_maxButton; /** The highest configured button */

/*--------------------------------------------------------------------------*
* Helper functions
*--------------------------------------------------------------------------*/

/** Log a message
 */
void logMessage(int priority, const char *cszFormat, ...) {
  va_list args;
  va_start(args, cszFormat);
  vsyslog(priority, cszFormat, args);
  va_end(args);
  }

/** Strip whitespace from the start and end of a string
 */
static int strip(char *szLine) {
  int index = 0;
  /* Strip leading whitespace */
  while(szLine[index]&&isspace(szLine[index]))
    index++;
  memcpy(szLine, &szLine[index], strlen(szLine) - index);
  /* Strip trailing whitespace */
  index = strlen(szLine) - 1;
  while((index>0)&&isspace(szLine[index]))
    index--;
  szLine[index + 1] = '\0';
  /* Return the length of the processed line */
  return index;
  }

/*--------------------------------------------------------------------------*
* The main daemon process
*--------------------------------------------------------------------------*/

/** Configure the daemon
 */
static void daemon_config(int argc, char *argv[]) {
  const char *cszConfigFile = CONFIG_FILE;
  if(argc>=2)
    cszConfigFile = argv[1];
  logMessage(LOG_INFO, "Reading configuration from '%s'", cszConfigFile);
  /* Now try and open the configuration file */
  FILE *fpConfig = fopen(cszConfigFile, "r");
  if(!fpConfig) {
    logMessage(LOG_CRIT, "Unable to read configuration file '%s'", cszConfigFile);
    exit(EXIT_FAILURE);
    }
  /* Process the entries in the file */
  char szLine[MAX_STRING];
  int iPort, iKey;
  g_maxButton = 0;
  while(fgets(szLine, MAX_STRING, fpConfig)) {
    /* Filter out comments and blank lines */
    if((strip(szLine)==0)||(szLine[0]=='#'))
      continue;
    /* Remaining lines should be two integers separated by spaces */
    if(sscanf(szLine, "%i:%i", &iPort, &iKey)<2) {
      logMessage(LOG_CRIT, "Could not parse line '%s'", szLine);
      exit(EXIT_FAILURE);
      }
    if(g_maxButton>=MAX_BUTTONS) {
      logMessage(LOG_CRIT, "More than %i buttons have been defined.", MAX_BUTTONS);
      exit(EXIT_FAILURE);
      }
    g_mapping[g_maxButton].m_pin = iPort;
    g_mapping[g_maxButton].m_key = iKey;
    g_mapping[g_maxButton].m_state = false;
    g_maxButton++;
    logMessage(LOG_INFO, "Mapping GPIO #%i to keycode %i", iPort, iKey);
    }
  /* Finished with the file */
  fclose(fpConfig);
  }

/** Initialise the daemon
 */
static void daemon_run() {
  int i, j;
  bool newstate[MAX_BUTTONS];
  /* Fork the process to start the daemon */
  pid_t pid, sid;
  pid = fork();
  if (pid < 0)
    exit(EXIT_FAILURE);
  if (pid > 0)
    exit(EXIT_SUCCESS);
  /* Set up the new process to act as a daemon */
  umask(0);
  sid = setsid();
  if (sid < 0) {
    syslog(LOG_CRIT, "Unable to set SID for the daemon.");
    exit(EXIT_FAILURE);
    }
  if ((chdir("/")) < 0) {
    syslog(LOG_CRIT, "Unable to change to root directory.");
    exit(EXIT_FAILURE);
    }
  /* Close out the standard file descriptors */
  syslog(LOG_INFO, "Entering daemon mode.");
  close(STDIN_FILENO);
  close(STDOUT_FILENO);
  close(STDERR_FILENO);
  /* Initialise the IO */
  if(wiringPiSetup()<0) {
    syslog(LOG_CRIT, "Could not initialise GPIO.");
    exit(EXIT_FAILURE);
    }
  for(i=0; i<g_maxButton; i++)
    pinMode(g_mapping[i].m_pin, INPUT);
  /* Enter the main loop
   *
   * In the loop we scan for key state changes approximately 5 times a second
   * which should be fast enough for most situations without having the daemon
   * chewing up too much processing power.
   */
  syslog(LOG_INFO, "Monitoring keyboard buttons.");
  while(true) {
    /* Set initial state */
    for(i=0; i<g_maxButton; i++)
      newstate[i] = false;
    /* Do a set of samples to try and filter out some of the bounce */
    for(j=0; j<3; j++) {
      for(i=0; i<g_maxButton; i++)
        newstate[i] = newstate[i] || !digitalRead(g_mapping[i].m_pin);
      /* Wait a little bit */
      delay(10);
      }
    /* Check for state changes */
    for(i=0; i<g_maxButton; i++) {
      if(g_mapping[i].m_state!=newstate[i]) {
        g_mapping[i].m_state = newstate[i];
        logMessage(LOG_INFO, "Sending event for key %i %s.", g_mapping[i].m_key, g_mapping[i].m_state?"DOWN":"UP");
        }
      }
    /* Wait for a bit before starting the next cycle */
    delay(150);
    }
  exit(EXIT_SUCCESS);
  }

/*--------------------------------------------------------------------------*
* Main program and initialisation code
*--------------------------------------------------------------------------*/

/** Program entry point
 */
int main(int argc, char *argv[]) {
  /* Set up logging */
  openlog(NULL, 0, 0);
  syslog(LOG_NOTICE, "Starting gpiokeys daemon");
  /* Configure and start the daemon */
  daemon_config(argc, argv);
  daemon_run();
  /* All done */
  closelog();
  return 0;
  }

