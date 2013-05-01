#!/usr/bin/env python
#-----------------------------------------------------------------------------
# 1-May-2013 ShaneG
#
# This is a simple test program to work with the GPIO buttons.
#-----------------------------------------------------------------------------
from time import sleep

# Bring in the GPIO library
try:
  import RPi.GPIO as GPIO
except:
  print "Unable to input GPIO library. Please install RPi.GPIO"
  exit(1)
  
#-----------------------------------------------------------------------------
# Main program
#-----------------------------------------------------------------------------

# Map the button pins to the P1 pin numbers
BUTTON_PINS = (12, 16, 18, 22)

if __name__ == "__main__":
  # Use board numbering for pins
  GPIO.setmode(GPIO.BOARD)
  # Initialise the pins
  try:
    for pin in BUTTON_PINS:
	  GPIO.setup(pin, GPIO.IN)
  except:
    print "Failed to initialise GPIO pins for buttons."
    exit(1)
  # Now keep reading the input
  try:
    while True:
      result = ""
      for pin in BUTTON_PINS:
        if GPIO.input(pin):
          result = result + "1"
        else:
		  result = result + "0"
      print result
      sleep(1)
  except:
	# Try and cleanup
	GPIO.cleanup()
	exit(1)
