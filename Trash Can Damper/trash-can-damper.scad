BASE_RADIUS = 18.75;
BASE_OUTER_RADIUS = 35;
SCREW_DISTANCE = 50;
SCREW_OFFSET = 10;
SCREW_HEIGHT = 2;
SCREW_RADIUS = 2;
SCREW_SUPPORT_THICKNESS = 1.5;
HEIGHT = 5;
NOTCH_WIDTH = 20;
NOTCH_HEIGHT = 6;
OUTER_SIDES = 8;

module screw() {
    translate([0, -(SCREW_DISTANCE / 2) - SCREW_RADIUS, -1]) {
        cylinder(SCREW_HEIGHT + 1, SCREW_RADIUS, SCREW_RADIUS, $fn = 16);
        
        translate([0, 0, SCREW_HEIGHT])
            cylinder(HEIGHT - SCREW_HEIGHT + 2, SCREW_RADIUS, SCREW_RADIUS, $fn = 16);
    }
}

difference() {
    // OUTER SHAPE
    rotate([0, 0, 360 / OUTER_SIDES])
        cylinder(HEIGHT, BASE_OUTER_RADIUS, BASE_OUTER_RADIUS, $fn = OUTER_SIDES);
    
    // OPENING
    translate([0, 0, -1])
        cylinder(HEIGHT + 2, BASE_RADIUS, BASE_RADIUS, $fn = 64);
    
    // BASE NOTCH
    rotate([0, 0, -22.5 - 180])
    translate([0, -NOTCH_WIDTH / 2, -1])    
        cube([40, NOTCH_WIDTH, NOTCH_HEIGHT + 1]);
    
    // SCREWS
    screw();
    mirror([0, 90, 0])
      rotate([0, 0, 45])
          screw();
    
    // SUPPORT SLICES
    rotate([0, 0, -45])
        translate([SCREW_SUPPORT_THICKNESS / -2, 0, -1])
            cube([SCREW_SUPPORT_THICKNESS, (SCREW_DISTANCE / 2) + SCREW_RADIUS, 10]);
    
    rotate([0, 0, -180])
        translate([SCREW_SUPPORT_THICKNESS / -2, 0, -1])
            cube([SCREW_SUPPORT_THICKNESS, (SCREW_DISTANCE / 2) + SCREW_RADIUS, 10]);

    // SCREW SUPPORTS 
    difference() {
      intersection() {
        rotate([0, 0, 360 / OUTER_SIDES])
          translate([0, 0, -1])
            cylinder(
              1 + 2.51, 
              BASE_OUTER_RADIUS * .925, 
              BASE_OUTER_RADIUS * .925, 
              $fn = OUTER_SIDES
            );

        rotate([0,0,-22.5 + 180])
          translate([0, 0, -1])  
            scale([.75, 1, 1])
              cylinder(3, 40, 40, $fn=3);
      }
      
      rotate([0, 0, 22.5 + 45])
        translate([-20, 10, -3])
            cube([40, 10, 10]);
    }
    
    rotate([0, 0, 22.5 + 45])
      translate([-30, -45, -3])
        cube([60, 20, 10]);
    
    rotate([0, 0, 22.5 + 45])
      translate([-30, 20, -3])
        cube([60, 20, 10]);
}



