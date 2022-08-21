$fn = 64;
linear_extrude(2, twist = 1.5, slices = 50)
scale([3, 3, 3])
//import("./letters/happy.svg");
//import("./letters/first.svg");
//import("./letters/day.svg");
import("./letters/bubs.svg");

*cube([80, 80, 80]);