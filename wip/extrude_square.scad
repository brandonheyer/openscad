ANGLE_STEP = 45;

difference() {
    union() {
        for(angle = [0 : ANGLE_STEP : 720]) {
            rotate([angle, 0, 0])
                rotate_extrude(angle = ANGLE_STEP)
                    translate([40, 0, 0])
                        circle(10, $fn = 5);
        };

        for (angle = [ANGLE_STEP / 2 : ANGLE_STEP : 360 + ANGLE_STEP / 2]) {
            rotate([angle, 0, 0])
                rotate_extrude(angle = ANGLE_STEP * 1.5)
                    translate([45, 0, 0])
                        circle(10, $fn = 6);
        };
        
    for (angle = [ANGLE_STEP / 4 : ANGLE_STEP / 2 : 360 + ANGLE_STEP / 4]) {
            rotate([angle, 0, 0])
                rotate_extrude(angle = ANGLE_STEP * 1.3)
                    translate([50, 0, 0])
                        circle(15, $fn = 3);
        };
    };

    rotate([0, 90, 0])
        translate([0, 0, 10])
            cylinder(30, 40, 20);
    
    
    rotate([0, 90, 0])
        translate([0, 0, 50])
            cylinder(20, 60, 60);
}