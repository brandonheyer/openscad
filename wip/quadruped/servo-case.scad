include <constants.scad>;
include <servo.scad>;
include <shoulderhull.scad>;
include <screws.scad>;
use <upper-arm.scad>;
use <lower-arm.scad>;

angledShoulder();

color("red")
  translate([-21.5, -2.65, -1.75])
    rotate([180, 0, 180])
      translate([-11, 29, 2.25])
        rotate([0, 80, 0])
          uap(full = true);

color("yellow")
  rotate([180, 0, 180])
    translate([8, 36.7, 3.8]) 
      rotate([0, 80, 0])
        translate([-47, 92, 0])
          rotate([-5, 15, 30])
            translate([0, 0, 1.5])
              lowerArmPair();

*servo(4, 40);