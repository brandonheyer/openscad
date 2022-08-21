include <constants.scad>;

module servo(ch = 2, cd = BUMP_D, screws = true, wire = true) {
  cube(S_BOX, center = true);
 
  translate([
    S_BOX[0] / 2 - 7.5 - 3, 
    0, 
    S_BOX[2] / 2 + ch / 2
  ]) 
    cylinder(ch + 0.1, d = cd, $fn = 64, center = true);
 
  if (screws) {
    translate([S_SCREWS[0] / 2, 0, 29.5 - S_BOX[2] / 2]) {
      translate([-S_BOX[0] / 2 - S_SCREWS[0] + 0.1, 0, 0]) {
        cube(S_SCREWS, center = true);
        
        translate([0, 0, S_SCREWS[2]])
          cube(
            [S_SCREWS[0], S_SCREWS[1] / 4, S_SCREWS[2] * 1.5], 
            center = true
          );
      }
       
      translate([S_BOX[0] / 2 - 0.1, 0, 0]) {
        cube(S_SCREWS, center = true);
        
        translate([0, 0, S_SCREWS[2]])
          cube(
            [S_SCREWS[0], S_SCREWS[1] / 4, S_SCREWS[2] * 1.5], 
            center = true
          );
      }
    }
  }
  
  if (wire) {
    translate([17 + (wire == true ? 7 : wire / 2), 0, -14])
      cube([wire == true ? 14 : wire, 8, 8], center = true);
  }
}

module servoMount(d = 10, h = 5, sd = SCREW_D + 0.2, screws = true, taper = 14, fn = 32, center = true) { 
  $fn = fn;

  difference() {         
    translate([0, 0, h / 2 + 0.5])
      cylinder(h, d, taper == false ? d : taper, center = true);
      
    if (screws) {
      for (i = [0 : 1 : 4]) {
        rotate([0, 0, i * 90])
          translate([7, 0, 0.1])
            cylinder(h + 2, d = sd);
      }
    }
     
   if (center) { 
      translate([0, 0, -1])
        cylinder(20, d = 5);
    }
  }
}

module servoMountSlicer(t = [0, 0, -10], h = 18, r1 = 11, r2 = 9) {
  difference() {
    children();
    
    translate(t)
      cylinder(h, r1, r2);
  }
}