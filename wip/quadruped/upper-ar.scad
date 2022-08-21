import <constants.scad>;
import <servo.scad>;

module upperArm(ph = 8, taper = true, screws = true, stops = 0) {
  translate([0, 0, -8]) {
    difference() {                            
      if (taper) {
        translate([0, 0, 3])
          cylinder(5, 10, 14, center = true);
      } else {
        translate([0, 0, 3])
          cylinder(5, 14, 14, center = true);  
      }
        
      if (screws) {
        for (i = [0 : 1 : 4]) {
          $fn = 32;
          
          rotate([0, 0, i * 90])
            translate([7, 0, -14])
              cylinder(20, d = SCREW_D + 0.2);
        }
      }
        
      translate([0, 0, -1])
        cylinder(20, d = 5);
    }
  }
  
  ARM_STOPS = [
    [
      [[-8, 30, 2], [15, 14]],
      [[-14, 48, 0], [12, 12]],
      [[-35, 78, -15], [14, 10]]
    ],
    [
      [[-14, 24, 2], [15, 14]],
      [[-24, 44, 0], [12, 12]],
      [[-36, 74, -15], [14, 10]]
    ]
  ];

  s = ARM_STOPS[stops];

  difference() {
    hull() {
      translate([0, 0, -1]) 
        cylinder(ph, 16, 13, center = true);
    
      translate(s[0][0])
        cylinder(ph + 4, s[0][1][0], s[0][1][1], center = true);
    }
    
    translate([0, 0, -10])
      cylinder(18, 11, 9);
  }
 
  hull() {
    translate(s[0][0])
        cylinder(ph + 4, s[0][1][0], s[0][1][1], center = true);
  
    translate(s[1][0])
      cylinder(ph + 4, s[1][1][0], s[1][1][1], center = true);
  }
  
  hull() {
    translate(s[1][0])
        cylinder(ph + 4, s[1][1][0], s[1][1][1], center = true);
  
    translate(s[2][0])
      cylinder(ph + 2, s[2][1][0], s[2][1][1], center = true);
  }
}