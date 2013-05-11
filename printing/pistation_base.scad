/*--------------------------------------------------------------------------*
* The printable base plate
*--------------------------------------------------------------------------*/
include <pistation.scad>

// Create the base plate
difference() {
  cube(size = [ FRAME_WIDTH, BLOCK_WIDTH, MDF_SIZE ], center = false);
  // Cut out the center so it's not as thick
  translate(v = [ 0, (2 * GENERAL_SPACE) - MDF_SIZE, 1 ]) {
    cube(size = [ FRAME_WIDTH, BLOCK_WIDTH - (2 * ((2 * GENERAL_SPACE) - MDF_SIZE)), MDF_SIZE ], center = false);
    }
  // Cut out notches for the front
  translate(v = [ FRAME_WIDTH - MDF_SIZE, 0, 0 ]) {
    cube(size = [ MDF_SIZE, (2 * GENERAL_SPACE) - MDF_SIZE, MDF_SIZE ], center = false);
    translate(v = [ 0, BLOCK_WIDTH - ((2 * GENERAL_SPACE) - MDF_SIZE), 0 ]) {
      cube(size = [ MDF_SIZE, (2 * GENERAL_SPACE) - MDF_SIZE, MDF_SIZE ], center = false);
      }
    }
  }

// Create a slot to hold the Raspberry Pi PCB
RASPBERRY_PI_WIDTH = 86;
RASPBERRY_PI_DEPTH = 18;
RASPBERRY_PI_SPACE = 20;
RASPBERRY_PI_SLOT  = 1.5;
RASPBERRY_PI_EDGE  = 2;

translate(v = [ RASPBERRY_PI_DEPTH - (RASPBERRY_PI_SLOT / 2), (BLOCK_WIDTH - RASPBERRY_PI_WIDTH) / 2, 0 ]) {
  difference() {
    cube(size = [ RASPBERRY_PI_SLOT * 3, RASPBERRY_PI_WIDTH, 2 + RASPBERRY_PI_EDGE ], center = false);
    translate(v = [ RASPBERRY_PI_SLOT, 0, 2 ]) {
      cube(size = [ RASPBERRY_PI_SLOT, RASPBERRY_PI_WIDTH, RASPBERRY_PI_EDGE ], center = false);
      }
    translate(v = [ 0, RASPBERRY_PI_SPACE, 1 ]) {
      cube(size = [ RASPBERRY_PI_SLOT * 3, RASPBERRY_PI_WIDTH - (2 * RASPBERRY_PI_SPACE), RASPBERRY_PI_EDGE + 1 ], center = false);
      }
    }
  }

// Create a slot to hold the power board
POWER_WIDTH = 50;
POWER_SLOT  = 1.5;
POWER_DEPTH = 3;
POWER_SPACE = 10;

translate(v = [ RASPBERRY_PI_DEPTH + (3 * RASPBERRY_PI_SLOT) + POWER_SPACE, BLOCK_WIDTH - ((BLOCK_WIDTH - RASPBERRY_PI_WIDTH) / 2) - POWER_WIDTH, 0 ]) {
  difference() {
    cube(size = [ POWER_SLOT * 3, POWER_WIDTH, POWER_DEPTH + 1 ], center = false);
    translate(v = [ POWER_SLOT, 0, 1 ]) {
      cube(size = [ POWER_SLOT, POWER_WIDTH, POWER_DEPTH + 1 ], center = false);
      }
    }
  }
