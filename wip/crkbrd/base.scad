
difference() {
  union() {
    import(
      "C:/Users/Brandon/openscad/crkbrd/crkbd-handwire-case.stl", 
      convexity = 5
    );
    
    translate([126.9, 58.9, -2])
        rotate([0, 90, 90])
        cylinder(r = 7, h = 2, $fn = 32);    
  }

  translate([126.9, 58, -2]) {
    rotate([0, 90, 90])
      cylinder(r = 4, h = 5, $fn = 32);

    *translate([0, 1, 5]) cube([8,5, 10], center = true);
  }
    
}

*translate([126.9, 58.9, -2]) {
  rotate([0, 90, 90])
    cylinder(r = 5, h = 2, $fn = 32);  
  #translate([0, 1, 5]) cube([8, 2, 10], center = true);
}