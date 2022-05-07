include <../scad/pipe-fittings.scad>;

translate([0, 0, 4])
  difference() {
    npt(3/4);
    cube([40, 40, 15], center = true);
  }

hull() {
  cylinder(4, 23, 23, $fn = 8);
  translate([0, 0, 4]) cylinder(4, 21, 21, $fn = 16);
  translate([0, 0, 8]) cylinder(4, 19, 19, $fn = 32);
}