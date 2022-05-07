difference() {
  translate([0, 0, -8]) {
    union() {
      translate([0, 0, 9]) cylinder(25, 28, 40, $fn = 16);
      translate([0, 0, 30.55]) 
        rotate_extrude(angle = 360, $fn = 16)
          translate([37.5, 0, 0]) 
            circle(8, $fn = 6);
    }
  }
  
  cylinder(37.5, 15, 40, $fn = 16);
  translate([0, 0, -25]) cylinder(50, 8, 8, $fn = 16);
}

