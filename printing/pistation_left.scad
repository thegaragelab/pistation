/*--------------------------------------------------------------------------*
* Describes the left hand side frame for the PiStation.
*--------------------------------------------------------------------------*/
include <pistation.scad>

// Create a frame and add cutouts for mounting
difference() {
  union() {
    frame();
    cube(size = [ FRAME_WIDTH, GENERAL_SPACE, GENERAL_SPACE * 2], center = false);
    }
  translate(v = [ MDF_SIZE, 0, GENERAL_SPACE - MDF_SIZE ]) {
    cube(size = [ FRAME_WIDTH, MDF_SIZE, 3 * GENERAL_SPACE ], center = false);
    }
  translate(v = [ 0, FRAME_STEP, GENERAL_SPACE - MDF_SIZE ]) {
    rotate(a = [ 0, 0, -FRONT_ANGLE ]) {
      cube(size = [ MDF_SIZE, BLOCK_HEIGHT + GENERAL_SPACE, GENERAL_SPACE ], center = false);
      }
    }
  }  

//cube(size = [ FRAME_WIDTH, FRAME_HEIGHT, GENERAL_SPACE ], center = false);
