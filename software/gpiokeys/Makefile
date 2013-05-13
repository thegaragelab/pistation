# Makefile for the GPIO daemon.
#----------------------------------------------------------------------------
# This is a simple makefile for the GPIO daemon processing the input buttons
# on the PiStation.
#----------------------------------------------------------------------------

OBJECTS := \
  gpiokeys.o

TARGET := gpiokeys

all: $(TARGET)

clean:
	$(RM) -f $(TARGET) $(OBJECTS)

$(TARGET): $(OBJECTS)
	$(CC) -o $(TARGET) $(OBJECTS)
