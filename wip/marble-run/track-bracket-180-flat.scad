{
    translate([0,0,-1.5]) 
        linear_extrude(3)
            import("track-bracket-180-3.svg", center=true);

    difference() {

            translate([0, -6, 0])
                cube([4, 6, 3], center=true);
        
        rotate([90, 0, 0])
            translate([0, 0, 5.4])
                cylinder(12, 1.1, 1.1, $fn = 16);
    }
}