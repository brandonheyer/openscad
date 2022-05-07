module nutHolder(h = 5, slicer = false, thickness = 2) {
  if (slicer) {
    translate([0, 0, -1])
      cylinder(h + 2, 7.51, 7.51, $fn = 6);
  } else {
    difference() {
      cylinder(h, 7.51 + thickness, 7.51 + thickness, $fn = 6);
      
      translate([0, 0, -1])
        cylinder(h + 2, 7.51, 7.51, $fn = 6);
    }
  }
}

module compassHolder(h = 5, slicer = false, thickness = 2, $fn = 64) {
  if (slicer) {
    translate([0, 0, -1])
      cylinder(h + 2, 5.1, 5.1, $fn = $fn);
  } else {
    difference() {
      cylinder(h, 5.1 + thickness, 5.1 + thickness);
        translate([0, 0, .5])
          cylinder(h, 5.1, 5.1, $fn = $fn);
    }
  }
}

module boltHeadSlicer(h = 5, $fn = 32) {
  translate([0, 0, -1])
    cylinder(h + 2, 8.1, 8.1, $fn = $fn);
}

translate([20, 15, -5]) {
    *compassHolder();
    *nutHolder(5, false);
    boltHeadSlicer();
    

    
    // BOLT HEAD SIZE
    translate([3, -18, 0])
    difference() {
        cylinder(2.5, 11, 11, $fn = 8);
        translate([0, 0, -1])
            cylinder(4, 8.1, 8.1, $fn = 32);
    }
    
    // MOTOR HOLDER
    translate([9, -6, 0]) {
        difference() {
            cube([14, 16, 2.5]);
            translate([2, 2, -2])
                cube([10, 12, 10]);
        }
    }
}
