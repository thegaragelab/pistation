/*--------------------------------------------------------------------------*
* Describes the front section for the PiStation. This part holds the screen
* and the buttons.
*--------------------------------------------------------------------------*/
include <pistation.scad>

// Make the buttons
module buttons() {
  for(btn = [ 0:3 ]) {
    translate(v = [ BUTTON_DIAMETER + (btn * (BUTTON_DIAMETER + BUTTON_SPACE)), BUTTON_DIAMETER / 2, 0 ]) {
      cylinder(h = LCD_OUTER_HEIGHT * 2, r = BUTTON_DIAMETER / 2, $fs = 0.1);
      }
    }
  }

// Main program
echo("Front panel size is ", BLOCK_WIDTH, " x ", BLOCK_HEIGHT);

difference() {
  // Create the main block (with mounts for the button PCB)
  union() {
    cube([ BLOCK_WIDTH, BLOCK_HEIGHT, BLOCK_DEPTH ], center = false);
    // Add the PCB mounts
    translate(v = [ (BLOCK_WIDTH - TOTAL_BUTTON_WIDTH) / 2 - (2 * GENERAL_SPACE), BLOCK_HEIGHT - BUTTON_BOARD - BUTTON_DIAMETER, 0 ]) {
      cube([ GENERAL_SPACE, BUTTON_DIAMETER, BLOCK_DEPTH + BUTTON_DEPTH ], center = false);
      translate(v = [ TOTAL_BUTTON_WIDTH + (3 * GENERAL_SPACE), 0, 0 ]) {
        cube([ GENERAL_SPACE, BUTTON_DIAMETER, BLOCK_DEPTH + BUTTON_DEPTH ], center = false);
        }
      }
    }
  // Cut out the holes for the LCD
  translate(v = [ GENERAL_SPACE, GENERAL_SPACE, LCD_INNER_DEPTH ]) {
    cube([ LCD_OUTER_WIDTH, LCD_OUTER_HEIGHT, LCD_OUTER_DEPTH + GENERAL_SPACE ], center = false);
    }
  translate(v = [ GENERAL_SPACE + LCD_LEFT_SPACE, GENERAL_SPACE + LCD_UPPER_SPACE, 0 ]) {
    cube([ LCD_INNER_WIDTH, LCD_INNER_HEIGHT, LCD_OUTER_DEPTH + GENERAL_SPACE ], center = false);
    }
  // Add the buttons
  translate(v = [ (BLOCK_WIDTH - TOTAL_BUTTON_WIDTH) / 2 - GENERAL_SPACE, BLOCK_HEIGHT - BUTTON_BOARD - BUTTON_DIAMETER, 0 ]) {
    buttons();
    }
  }
