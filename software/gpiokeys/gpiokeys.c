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
#include <stdlib.h>
#include <stdarg.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <syslog.h>
#include <string.h>

/*--------------------------------------------------------------------------*
* Constants and structures
*--------------------------------------------------------------------------*/

/** Default configuration file */
#define CONFIG_FILE "/etc/gpiokeys.cfg"

/** Maximum length of strings */
#define MAX_STRING 256

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
  while(fgets(szLine, MAX_STRING, fpConfig)) {
    /* Filter out comments and blank lines */
    if((strip(szLine)==0)||(szLine[0]=='#'))
      continue;
    /* Remaining lines should be two integers separated by spaces */
    if(sscanf(szLine, "%i:%i", &iPort, &iKey)<2) {
      logMessage(LOG_CRIT, "Could not parse line '%s'", szLine);
      exit(EXIT_FAILURE);
      }
    logMessage(LOG_CRIT, "Mapping GPIO #%i to keycode %i", iPort, iKey);
    }
  /* Finished with the file */
  fclose(fpConfig);
  }

/** Initialise the daemon
 */
static void daemon_run() {
  /* Close the current log */
  closelog();
  /* Fork the process to start the daemon */
  pid_t pid, sid;
  pid = fork();
  if (pid < 0)
    exit(EXIT_FAILURE);
  if (pid > 0)
    exit(EXIT_SUCCESS);
  /* Set up the new process to act as a daemon */
  umask(0);
  openlog(NULL, 0, 0);
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
  close(STDIN_FILENO);
  close(STDOUT_FILENO);
  close(STDERR_FILENO);
  /* Enter the main loop */
  syslog(LOG_DEBUG, "Entering main loop.");
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

