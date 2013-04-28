/* A simple frame for PCB's
**----------------------------------------------------------------------------------
** 29-Dec-2012 shaneg
**
** This is a simple holding frame for bare PCB boards. It can be scaled to hold any
** sized board (limited only by your print area).
**--------------------------------------------------------------------------------*/

/* PCB Dimensions
**
** Set the dimensions of your board (in mm). All other measurements are derived from
** these values. The sample values below are for a Raspberry Pi Model B.
*/
PCB_WIDTH     = 56;  // Width of the PCB in mm
PCB_BREADTH   = 86;  // Length of the PCB in mm
PCB_HEIGHT    = 1;   // Height of the board itself
PCB_CLEARANCE = 4;   // Gap between the base of the PCB and the base plate.
PCB_EDGE_CLIP = 2;   // Gap for the clip in the mounts
MOUNT_SIZE    = 6;   // Size of the mounts (they are square)
MOUNT_EXTRA   = 4;   // Extra space above the clip hole
FUDGE_FACTOR  = 0.3; // Extra space when using PCB clip holes

/* PCB Dimensions for a Gumstix Tobi
**   See - https://www.gumstix.com/store/product_info.php?products_id=230
**
PCB_WIDTH     = 40;  // Width of the PCB in mm
PCB_BREADTH   = 105; // Length of the PCB in mm
PCB_HEIGHT    = 1;   // Height of the board itself
PCB_CLEARANCE = 4;   // Gap between the base of the PCB and the base plate.
PCB_EDGE_CLIP = 2;   // Gap for the clip in the mounts
MOUNT_SIZE    = 6;   // Size of the mounts (they are square)
MOUNT_EXTRA   = 4;   // Extra space above the clip hole
FUDGE_FACTOR  = 0.3; // Extra space when using PCB clip holes
*/

/* PCB Dimensions for a Gumstix Chestnut43
**  See - https://www.gumstix.com/store/product_info.php?products_id=237
**
PCB_WIDTH     = 68;  // Width of the PCB in mm
PCB_BREADTH   = 118; // Length of the PCB in mm
PCB_HEIGHT    = 1;   // Height of the board itself
PCB_CLEARANCE = 24;  // Gap between the base of the PCB and the base plate.
PCB_EDGE_CLIP = 2;   // Gap for the clip in the mounts
MOUNT_SIZE    = 6;   // Size of the mounts (they are square)
MOUNT_EXTRA   = 4;   // Extra space above the clip hole
FUDGE_FACTOR  = 0.3; // Extra space when using PCB clip holes
*/

/* PCB Dimensions for the breadboard power supply
**
PCB_WIDTH     = 25;  // Width of the PCB in mm
PCB_BREADTH   = 55;  // Length of the PCB in mm
PCB_HEIGHT    = 1;   // Height of the board itself
PCB_CLEARANCE = 4;   // Gap between the base of the PCB and the base plate.
PCB_EDGE_CLIP = 2;   // Gap for the clip in the mounts
MOUNT_SIZE    = 6;   // Size of the mounts (they are square)
MOUNT_EXTRA   = 4;   // Extra space above the clip hole
FUDGE_FACTOR  = 0.3; // Extra space when using PCB clip holes
*/

/* PCB Dimensions for the breadboard power supply
**
PCB_WIDTH     = 47;  // Width of the PCB in mm
PCB_BREADTH   = 72;  // Length of the PCB in mm
PCB_HEIGHT    = 2;   // Height of the board itself
PCB_CLEARANCE = 4;   // Gap between the base of the PCB and the base plate.
PCB_EDGE_CLIP = 3;   // Gap for the clip in the mounts
MOUNT_SIZE    = 6;   // Size of the mounts (they are square)
MOUNT_EXTRA   = 4;   // Extra space above the clip hole
FUDGE_FACTOR  = 0.3; // Extra space when using PCB clip holes
*/

/* PCB Dimensions for AVR programmer adaptor
**
PCB_WIDTH     = 66;  // Width of the PCB in mm
PCB_BREADTH   = 65;  // Length of the PCB in mm
PCB_HEIGHT    = 1;   // Height of the board itself
PCB_CLEARANCE = 4;   // Gap between the base of the PCB and the base plate.
PCB_EDGE_CLIP = 2;   // Gap for the clip in the mounts
MOUNT_SIZE    = 6;   // Size of the mounts (they are square)
MOUNT_EXTRA   = 4;   // Extra space above the clip hole
FUDGE_FACTOR  = 0.3; // Extra space when using PCB clip holes
*/

/* The base plate size
**
** Specifies the size of the base plate. Most of these are calculated from the values
** given above. The things you might need to change are the 'BASE_PLATE_HEIGHT' value
** which specifies the height of the base plate itself and the 'BASE_PLATE_EXTRA' value
** which specifies the additional space to add to the base plate rectangle if you
** need to add mounting holes etc.
*/
BASE_PLATE_WIDTH   = PCB_WIDTH + (2 * (MOUNT_SIZE - FUDGE_FACTOR - PCB_EDGE_CLIP));
BASE_PLATE_BREADTH = PCB_BREADTH + (2 * (MOUNT_SIZE - FUDGE_FACTOR - PCB_EDGE_CLIP));
BASE_PLATE_HEIGHT  = 2;
BASE_PLATE_EXTRA   = 2;

/* Size of the base plate hole.
**
** This is the hole cut into the base plate to minimise the amount of plastic that
** you need. The values here are calculated from the settings above. If you want a
** solid base plate set both of these to zero.
*/
BASE_PLATE_HOLE_WIDTH   = BASE_PLATE_WIDTH - (2 * MOUNT_SIZE) - (2 * BASE_PLATE_EXTRA);
BASE_PLATE_HOLE_BREADTH = BASE_PLATE_BREADTH - (2 * MOUNT_SIZE) - (2 * BASE_PLATE_EXTRA);

/*----------------------------------------------------------------------------------
** Customisation modules
**--------------------------------------------------------------------------------*/

/* Modify the base plate
**
** The objects defined here will be subtracted from the base plate. You can
** use this to define mounting holes, etc. The example code given here creates
** holes for M3 mounting bolts - if you want to do this you should increase
** the value of 'BASE_PLATE_EXTRA' to 5 or more.
*/
module modify_baseplate() {
/* Sample code to create M3 mounting holes
**
** See notes above for more details.
**
  mid_width = (BASE_PLATE_HOLE_WIDTH / 2) + ((BASE_PLATE_WIDTH - BASE_PLATE_HOLE_WIDTH) / 4);
  mid_breadth = (BASE_PLATE_HOLE_BREADTH / 2) + ((BASE_PLATE_BREADTH - BASE_PLATE_HOLE_BREADTH) / 4);
  // Generate mounting holes for M3 bolts on each edge of the frame
  translate(v = [ 0, mid_breadth, 0 ]) {
    cylinder(r = 1.5 + (2 * FUDGE_FACTOR), h = 3 * BASE_PLATE_HEIGHT, center = true, $fs = 0.3);
    }
  translate(v = [ 0, -mid_breadth, 0 ]) {
    cylinder(r = 1.5 + (2 * FUDGE_FACTOR), h = 3 * BASE_PLATE_HEIGHT, center = true, $fs = 0.3);
    }
  translate(v = [ mid_width, 0, 0 ]) {
    cylinder(r = 1.5 + (2 * FUDGE_FACTOR), h = 3 * BASE_PLATE_HEIGHT, center = true, $fs = 0.3);
    }
  translate(v = [ -mid_width, 0, 0 ]) {
    cylinder(r = 1.5 + (2 * FUDGE_FACTOR), h = 3 * BASE_PLATE_HEIGHT, center = true, $fs = 0.3);
    }
*/
  }

/*----------------------------------------------------------------------------------
** Generate the components
**--------------------------------------------------------------------------------*/

/** Generate a single mount point
 */
module mount_point() {
  mp_height = BASE_PLATE_HEIGHT + PCB_CLEARANCE + PCB_HEIGHT + (FUDGE_FACTOR * 2) + MOUNT_EXTRA;
  translate(v = [ 0, 0, mp_height / 2 ]) {
    cube(size = [ MOUNT_SIZE, MOUNT_SIZE, mp_height ], center = true);
    }
  }

/** Generate all four mount points
 */
module mount_points() {
  clip_adjust = MOUNT_SIZE / 2;
  notch_width = PCB_WIDTH + (2 * FUDGE_FACTOR);
  notch_breadth = PCB_BREADTH + (2 * FUDGE_FACTOR);
  notch_height = PCB_HEIGHT + (2 * FUDGE_FACTOR);
  difference() {
    union() {
      translate(v = [ (BASE_PLATE_WIDTH / 2 - clip_adjust), (BASE_PLATE_BREADTH / 2 - clip_adjust), 0 ]) {
        mount_point();
        }
      translate(v = [ -(BASE_PLATE_WIDTH / 2 - clip_adjust), (BASE_PLATE_BREADTH / 2 - clip_adjust), 0 ]) {
        mount_point();
        }
      translate(v = [ (BASE_PLATE_WIDTH / 2 - clip_adjust), -(BASE_PLATE_BREADTH / 2 - clip_adjust), 0 ]) {
        mount_point();
        }
      translate(v = [ -(BASE_PLATE_WIDTH / 2 - clip_adjust), -(BASE_PLATE_BREADTH / 2 - clip_adjust), 0 ]) {
        mount_point();
        }
      }
    // Cut the notches
    translate(v = [ 0, 0, (notch_height / 2) + BASE_PLATE_HEIGHT + PCB_CLEARANCE ]) {
      cube(size = [ notch_width, notch_breadth, notch_height ], center = true);
      }
    }
  }

/** Generate the base plate
 *
 */
module baseplate() {
  translate(v = [ 0, 0, BASE_PLATE_HEIGHT / 2]) {
    difference() {
      cube(size = [ BASE_PLATE_WIDTH, BASE_PLATE_BREADTH, BASE_PLATE_HEIGHT ], center = true);
      cube(size = [ BASE_PLATE_HOLE_WIDTH, BASE_PLATE_HOLE_BREADTH, 2 * BASE_PLATE_HEIGHT ], center = true);
      }
    }
  }

/*----------------------------------------------------------------------------------
** Main object
**--------------------------------------------------------------------------------*/

union() {
  mount_points();
  difference() {
    baseplate();
    modify_baseplate();
    }
  }

