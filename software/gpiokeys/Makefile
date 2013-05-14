# Makefile for the GPIO daemon.
#----------------------------------------------------------------------------
# This is a simple makefile for the GPIO daemon processing the input buttons
# on the PiStation.
#----------------------------------------------------------------------------
TOP := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)

DESTDIR=/usr
PREFIX=/local

INCLUDE	+= -I$(TOP)/out/include
CFLAGS	+= -O2 -Wall $(INCLUDE) -Winline -pipe

LIBS    += -lpthread -lm

OBJECTS := \
  gpiokeys.o

TARGET := gpiokeys

all: $(TARGET)

install: $(TARGET)
	@install -m 0755 -d			$(DESTDIR)$(PREFIX)/bin
	@install -m 0755 $(TARGET)		$(DESTDIR)$(PREFIX)/bin
	@install -m 0755 -d			$(DESTDIR)$(PREFIX)/etc
	@install -m 0644 gpiokeys.cfg		$(DESTDIR)$(PREFIX)/etc

clean:
	$(RM) -f $(TARGET) $(OBJECTS)

$(TARGET): $(OBJECTS)
	$(CC) -o $(TARGET) $(OBJECTS) $(TOP)/out/lib/libwiringPi.a $(LDFLAGS) $(LIBS)
