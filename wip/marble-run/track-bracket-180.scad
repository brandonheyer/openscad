translate([0,0,9]) rotate([90, 0, 0]) {
    translate([0,0,-0.5]) 
        linear_extrude(1)
            import("track-bracket-180.svg", center=true);

    difference() {
        union() {
            rotate([90, 18, 0])
                translate([0, 0, 0])
                    cylinder(3, 1, 2.2, $fn = 10);
                  
            rotate([90, 18, 0])
                translate([0, 0, 3])
                    cylinder(6, 2.2, 2.2, $fn = 10);
        }
        
        rotate([90, 0, 0])
            translate([0, 0, 5.4])
                cylinder(12, .9, .9, $fn = 8);
    }
}