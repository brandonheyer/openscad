include <./constants.scad>;
use <./library.scad>;

spacing = 10;
xSleeves = 3;
ySleeves = 3;

for(x = [1 : spacing : xSleeves * spacing]) {
    for (y = [1 : spacing : ySleeves * spacing]) {
        translate([x, y, 0]) {
            baseSleeve();
            
            if (x < (xSleeves - 1) * spacing) {
                translate([(SLEEVE_RADIUS - BASE_RADIUS), -.5, -1])
                    cube([spacing - (SLEEVE_RADIUS - BASE_RADIUS) * 2, 1, 3]);
            }
            
            if (y < (ySleeves - 1) * spacing) {
                rotate([0, 0, 90])                
                    translate([(SLEEVE_RADIUS - BASE_RADIUS), -.5, -1])
                        cube([spacing - (SLEEVE_RADIUS - BASE_RADIUS) * 2, 1, 3]);
            }
        }
    }
}
