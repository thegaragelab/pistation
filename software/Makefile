# Master makefile for the PiStation utilities
#----------------------------------------------------------------------------
TOP := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

all:
	mkdir out
	# Build support libraries
	make -C WiringPi/wiringPi CC=$(CC)
	make -C WiringPi/wiringPi DESTDIR=$(TOP)/out PREFIX= install
	make -C WiringPi/wiringPi DESTDIR=$(TOP)/out PREFIX= install-static
	# Build the GPIO daemon
	make -C gpiokeys CC=$(CC)
	make -C gpiokeys CC=$(CC) DESTDIR=$(TOP)/out PREFIX= install

clean:
	make -C gpiokeys CC=$(CC) clean
	make -C WiringPi/wiringPi CC=$(CC) clean
	rm -rf out

