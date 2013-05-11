/*--------------------------------------------------------------------------*
* Defines all the sizes we need. This file is used by all other SCADs
*--------------------------------------------------------------------------*/

// Define the dimensions of the things we need to place
LCD_OUTER_WIDTH  = 105;
LCD_OUTER_HEIGHT = 68;
LCD_OUTER_DEPTH  = 3;

LCD_INNER_WIDTH  = 98;
LCD_INNER_HEIGHT = 57;
LCD_INNER_DEPTH  = 1;

LCD_UPPER_SPACE = 3;
LCD_LOWER_SPACE = 8;
LCD_LEFT_SPACE  = 3.5;
LCD_RIGHT_SPACE = 3.5;

BUTTON_DIAMETER = 10;
BUTTON_DEPTH    = 7;
BUTTON_SPACE    = 3;
BUTTON_BOARD    = 18;

GENERAL_SPACE   = 6;

FRAME_WIDTH = 80;
FRAME_STEP  = 10;

FRONT_ANGLE = 10;

MDF_SIZE = 3;

// Now calculate the extra sizes
BLOCK_WIDTH  = 1 + GENERAL_SPACE + LCD_OUTER_WIDTH + GENERAL_SPACE + 1;
BLOCK_HEIGHT = GENERAL_SPACE + LCD_OUTER_HEIGHT + GENERAL_SPACE + BUTTON_DIAMETER + BUTTON_BOARD;
BLOCK_DEPTH  = LCD_OUTER_DEPTH + LCD_INNER_DEPTH;

TOTAL_BUTTON_WIDTH  = (4 * BUTTON_DIAMETER) + (3 *BUTTON_SPACE);
TOTAL_BUTTON_HEIGHT = BUTTON_DIAMETER;

PANEL_SIDE_WIDTH  = BLOCK_HEIGHT * sin(FRONT_ANGLE);
PANEL_SIDE_HEIGHT = BLOCK_HEIGHT * cos(FRONT_ANGLE);

FRAME_HEIGHT = FRAME_STEP + PANEL_SIDE_HEIGHT;

/** Create a frame
 *
 * This creates the left frame (without any cutouts). It is used as the basis
 * for the left and right frame SCAD files.
 */
module frame() {
  // Let's make the frame components
  cube(size = [ FRAME_WIDTH, GENERAL_SPACE, GENERAL_SPACE ], center = false);
  cube(size = [ GENERAL_SPACE, FRAME_STEP, GENERAL_SPACE ], center = false);
  translate(v = [ PANEL_SIDE_WIDTH, 0, 0 ]) {
    cube(size = [ GENERAL_SPACE, FRAME_HEIGHT, GENERAL_SPACE ], center = false);
    }
  translate(v = [ 0, FRAME_STEP, 0 ]) {
    rotate(a = [ 0, 0, -FRONT_ANGLE ]) {
      cube(size = [ GENERAL_SPACE, BLOCK_HEIGHT, GENERAL_SPACE ], center = false);
      }
    }
  }

