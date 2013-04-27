/*--------------------------------------------------------------------------*
* Describes the front section for the PiStation. This part holds the screen
* and the buttons.
*--------------------------------------------------------------------------*/
include <pistation.scad>

// Make the buttons
module buttons() {
  for(btn = [ 0:3 ]) {
    translate(v = [ BUTTON_DIAMETER / 2, BUTTON_DIAMETER + (btn * (BUTTON_DIAMETER + BUTTON_SPACE)), 0 ]) {
      cylinder(h = LCD_OUTER_HEIGHT * 2, r = BUTTON_DIAMETER / 2, $fs = 0.1);
      }
    }
  }

// Main program
difference() {
  // Create the main block (with mounts for the button PCB)
  union() {
    cube([ BLOCK_WIDTH, BLOCK_HEIGHT, BLOCK_DEPTH ], center = false);
    translate(v = [ BLOCK_WIDTH - BUTTON_DIAMETER - GENERAL_SPACE, BLOCK_HEIGHT - (1.5 * GENERAL_SPACE), BLOCK_DEPTH ]) {
      cube([ BUTTON_DIAMETER, GENERAL_SPACE, 7 ], center = false);
      }
    translate(v = [ BLOCK_WIDTH - BUTTON_DIAMETER - GENERAL_SPACE, GENERAL_SPACE, BLOCK_DEPTH ]) {
      cube([ BUTTON_DIAMETER, GENERAL_SPACE, 7 ], center = false);
      }
    }
  // Cut out the holes for the LCD
  translate(v = [ GENERAL_SPACE, GENERAL_SPACE, LCD_INNER_DEPTH ]) {
    cube([ LCD_OUTER_WIDTH, LCD_OUTER_HEIGHT, LCD_OUTER_DEPTH + GENERAL_SPACE ], center = false);
    }
  translate(v = [ GENERAL_SPACE + LCD_LEFT_SPACE, GENERAL_SPACE + LCD_UPPER_SPACE, 0 ]) {
    cube([ LCD_INNER_WIDTH, LCD_INNER_HEIGHT, LCD_OUTER_DEPTH + GENERAL_SPACE ], center = false);
    }
  translate(v = [ GENERAL_SPACE + LCD_OUTER_WIDTH + GENERAL_SPACE, GENERAL_SPACE + LCD_UPPER_SPACE + (LCD_INNER_HEIGHT - TOTAL_BUTTON_HEIGHT) / 2, 0 ]) {
    buttons();
    }
  }
