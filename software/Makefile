# Master makefile for the PiStation utilities
#----------------------------------------------------------------------------

all:
	mkdir out
	make -C WiringPi/wiringPi CC=$(CC)
	make -C WiringPi/wiringPi DESTDIR=out PREFIX= install

clean:
	make -C WiringPi/wiringPi CC=$(CC) clean
	rm -rf out

