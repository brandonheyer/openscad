include <constants.scad>;
include <servo.scad>;
include <screws.scad>;

module upperArm(screws = true, stops = 0) {
  translate([2, 7, screws ? -10 : -6]) {
    servoMount(
      d = screws ? 10 : 12, 
      h = screws ? 4 : 7, 
      taper = screws ? 16 : 10, 
      screws = screws,
      fn = 64
    );
  }
  
  ARM_STOPS = [
    [
      [[2, 7, 3.5], [10, 9], 4],
      [[0, 30, 5], [9, 8], 6],
      [[-10, 55, 0], [9, 8], 5],
      [[-38, 84, -16], [0, 10], 8]
    ],
    [
      [[2, 7, -3], [16, 13], 5],
      [[-16, 28, 2], [10, 7], 8],
      [[-28, 48, -4], [10, 5], 7],
      [[-47, 70, -24], [2, 9], 15]
    ]
  ];

  s = ARM_STOPS[stops];

  difference() {
    hull() {
      $fn = 128;
     
      translate(s[0][0]) 
        cylinder(
          s[0][2],
          s[0][1][0],
          s[0][1][1], 
          center = true
        );
    
      translate(s[1][0])
        cylinder(
          s[1][2],
          s[1][1][0], 
          s[1][1][1], 
          center = true
        );
    }
    
    if (screws) {
      translate([2, 7, -8])
        cylinder(18, 12, 11);
    }
  }
 
  hull() {
    translate(s[1][0])
      cylinder(
        s[1][2], 
        s[1][1][0], 
        s[1][1][1], 
        center = true
      );
  
    translate(s[2][0])
      cylinder(
        s[2][2], 
        s[2][1][0],
        s[2][1][1], 
        center = true
      );
  }
  
  hull() {
    translate(s[2][0])
        cylinder(
          s[2][2],
          s[2][1][0], 
          s[2][1][1], 
          center = true
        );
  
    translate(s[3][0])
      cylinder(
        s[3][2],
        s[3][1][0], 
        s[3][1][1], 
        center = true
      );
  }
}

module upperArmPair(arm = false, noArm = false, screws = true) {
  difference() { 
    union() {
      $fn = 64;   
      h = S_BOX[2] + 19;
      sh = 28; 
      tz = -14;
      
      if (!noArm && arm) {
        translate([0, -5, 0])
          rotate([0, 0, -2])
            translate([0, 0, (h + 10) / -2])
              mirror([0, 0, 1])
                upperArm(stops = 1);
        
        
                  
      } else if (!noArm) {
        translate([0, -5, 0])
          rotate([0, 0, -2])
            translate([0, 0, (h + 10) / 2 + 1])
              upperArm(screws = false);
      }
               
      hull() 
        translate([-47, 89, 0]) {
          rotate([-5, 15, 30]) {
            // Top Left
            translate([tz + 4, -14, 20])
              rotate([0, 90, 0])
                cylinder(sh - 5, 12, 14); 

            // Cord Out
            difference() {
              translate([tz + 3, 5, 12])
                rotate([0, 90, 0])
                  cylinder(sh - 2.4, 25, 25, $fn = 128);
                  
              translate([tz - .6, -20, 29.5]) 
                cube([sh + 5, 60, 20]);
            }                  
            
            // Horn Side Far
            rotate([0, -15, 0])
              translate([tz - 5, -12, -6])
                rotate([0, 90, 0])
                  cylinder(sh, 17, 21); 
            
            
            // Horn Side Close
            rotate([0, -15, 0])
              translate([tz - 6, 20, -6.4])
                rotate([0, 90, 0])
                  cylinder(sh + 3, 17, 19);
          }
    
        }
      }
      
    if (screws)   
    translate([-47, 92, 0]) {
      rotate([-5, 15, 30]) {
        screwHole = arm ? SCREW_D : 2.5;
        rotate([0, 0, 90]) 
          scale([1.01, 1.01, 1]) {
            servo(6, 11, false, false);
            servo(20, 7, false, false);
          }
            
          mirror([0, 0, 0]) 
            rotate([180, 0, 90])
              scale([1.01, 1.01, 1])
                servo(20, 24, wire = 8); 
            
          translate([.1, 10.05, 32])
            cylinder(9, 6, 24, center = true);
    
        
          // Small Axel Screws
          group() {
            screwSlicer(
              r = [0, 270, 0],
              t2 = [24.5, -1, 6],
              h = 18,
              sd = screwHole,
              sh = 14
            );

            screwSlicer(
              r = [0, 270, 0],
              t2 = [23.5, 20, 6],
              h = 18,
              sd = screwHole,
              sh = 14
            );
          }
         
          // Servo Horn Side Screws
          group() {
            screwSlicer(
              r = [0, 270, 0],
              t2 = [-19, 26.4, 11],
              h = 18,
              sd = screwHole,
              sh = 20
            );

            screwSlicer(
              r = [0, 270, 0],
              t2 = [-22.8, -8, 11],
              h = 18,
              sd = screwHole,
              sh = 20
            );
          }
          
          screwSlicer(
            r = [0, 270, 0],
            t2 = [-4, -24.5, 11],
            h = 18,
            sd = screwHole,
            sh = 18
          );
          
          screwSlicer(
            r = [0, 270, 0],
            t2 = [23.5, -23, 11],
            h = 18,
            sd = screwHole,
            sh = 18
          );
      }    
    }
  }
}

module uaServoSlicer(arm = true) {
  rotate([20, 16, -3])
    rotate([0, 100, 30])
      rotate([0, 0, 12])
        translate([40, 51, 4.4])
          union() {   
            *rotate([0, 0, -43]) 
              translate([-24.5, 17.5, 0]) 
                cube([30, 30, 30]);
            
            *rotate([0, 0, 55]) 
              translate([22, -40, 0]) 
                cube([50, 30, 30]);
            
            rotate([0, 0, 47]) {
              translate([10.15, -10.5, 0])
                cube([10, 16, 30]);
          
              translate([16.6, -16, 0])
                cube([80, 60, 20]);
           
              translate([26, -30, 0])
                cube([80, 80, 20]);
              
              translate([0, 5, 0])
                cube([40, 40, 20]);
            }
              
            translate([18.4, 4.2, 0])
                cylinder(20, d = 11);
          }
          
  if (!arm) {
    difference() {
      rotate([20, 16, -3])
        rotate([0, 100, 30])
          rotate([0, 0, 12])
            translate([40, 51, 4.4])
              rotate([0, 0, 47])
                translate([-85, 20, -20])
                  cube([100, 80, 40]);
      
      
      scale([.997  , .997    , 1])
        upperArmPair(noArm = true, screws = false);
    }
  }
}

module uap(arm = false, full = false) {
  if (full) {
    upperArmPair(arm || full);
  } else {
    $fn = 64;
      h = S_BOX[2] + 19;
    if (arm) { 
      difference() { 
        upperArmPair(true); 
        uaServoSlicer();
      }
    } else {
      difference() {
        intersection() { 
          upperArmPair(false);
          uaServoSlicer(false);
        }
          translate([-47, 89, 0])
            rotate([-5, 15, 30])
              translate([0, 22.8, 6.6]) {
                cube([11.8, 5, 12]);
                
                translate([10, -65, 0])
                  cube([4, 70, 10]);
              }
      }
    }
  }
}

uap(arm = false);