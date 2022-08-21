include <./constants.scad>;
use <./library.scad>;

*bracketAndBase();

bracket(ring = true);

*translate([0, 0, 0]) cube([6.1, 1, 20], center = true);