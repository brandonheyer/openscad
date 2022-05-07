include <./constants.scad>;
use <./library.scad>;

ANGLE = 15;


module track() {
  difference() {
   square([MARBLE_RADIUS * 3.5, MARBLE_RADIUS * 1.5]);

    translate([MARBLE_RADIUS * 1.5, 0, 0])
      circle(MARBLE_RADIUS * 1.3, $fn = 8);
  }
}

difference() {
  union() {
      for (i = [ANGLE:ANGLE:360]) {
        translate([cos(i) * 1, sin(i) * 1, i * .04])
          rotate([0, 0, i])
            rotate_extrude(angle = -ANGLE * 1.5, convexity = 2)
        rotate([0, 0, 0])
              translate([0, 0, 0])
                 track();
      }
  }

  difference() {
  cylinder(23, 19, 19, $fn = 8);
    translate([0, 0, -1])
      cylinder(25, 17, 17, $fn = 8);
  }
}

cylinder(21.5, 2.5, 2.5, $fn = 8);
  
translate([0, 0, 21.5])
  cylinder(1, 18, 18, $fn = 8);