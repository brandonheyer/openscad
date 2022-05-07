include <./constants.scad>;
use <./library.scad>;

module holder(width = BASE_WIDTH) {
    baseHeight = 5.5;
    sleeveOffset = 2;
    sleeveHeight = 5;
    supportHeight = (width - WIRE_DIAMETER) / 2;
    supportWidth = width / 3;

    
    union() {
        rotate([-90, 0, 0]) {
            translate([0, 3, 0]) 
                difference() {
                    translate([0, 0, .25])
                    base(width, riser = false, rotation = 0);

                    translate([-width + 1, -2, 2.75])
                        rtCube(width + 2, 5, 0, 0, h = DEFAULT_HEIGHT + 1);
                    
                }
            
            translate([-width / 2, 2, width / -2.25])
                rtCube(width, 1, 0, 0, h = width / 2);

            translate([-width / 2, 2, (width / -2)])    
                rtCube(width, 4, 0, 0, h = 1);

            translate([-width / 2 - 0, 0, (width / -2)])    
                cube([width, 2, width]);
            

        }
        

        sleeve(supportWidth, sleeveHeight, baseHeight, quad = false);
    }
}

    holder(5.5);