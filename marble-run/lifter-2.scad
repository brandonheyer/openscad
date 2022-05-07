include <./constants.scad>;
include<./threads.scad>
use <./library.scad>

GEAR_1_D = 15.9;
GEAR_1_R = GEAR_1_D / 2;
GEAR_1_P = 12;
GEAR_2_D = 61.53;
GEAR_2_R = GEAR_2_D / 2;
GEAR_2_P = 63;

DEFAULT_SCALE = 1;
DEFAULT_HEIGHT = MARBLE_DIAMETER;

HOLE_ROTATION = 45;
HOLE_SCALE_OFFSET = .66;

SQRT22 = sqrt(2)/2;
DRIVE_GEAR_X = DEFAULT_SCALE * ((GEAR_1_P / 2) + (GEAR_2_P / 2));;
DRIVE_GEAR_Y = 0;
WALL_THICKNESS = 4;
BASE_HEIGHT = DEFAULT_HEIGHT + (WALL_THICKNESS * 2) + 2;

module gearOne(h = 1, r = 0, s = 1) {
    scale([s, s, 1])
        rotate([0, 0, r])
            linear_extrude(h)
                import("gear-8-toothed.svg", convexity=0);
}

module gearTwo(h = 1, r = 0, s = 1) {
    scale([s, s, 1])
        rotate([0, 0, r])
            linear_extrude(h)
                import("gear-2-half.svg");
}

module holeRotate(r = 20, zr = 0, t = .75) {
    for (r=[0:r:360]) {
        translate([cos(r) * GEAR_2_R * t, sin(r) * GEAR_2_R * t, 0])
            rotate([0, 0, r])
                rotate([0, zr, 0])
                    translate([0, 0, 0]) {
                        children();
                    }
    }
}



*rotate([0, 0, -30]) {
  // DRIVE GEAR
  translate([DRIVE_GEAR_X - .5, -0, 0]) {
      difference() {
          gearOne(DEFAULT_HEIGHT, 12.5, DEFAULT_SCALE);
              cylinder(DEFAULT_HEIGHT + 2, 1.5, 1.5, $fn = 32);
      }
  }

  // MAIN GEAR
  rotate([0, 0, 30])
    intersection() {
      union() {
          difference() {
              gearTwo(DEFAULT_HEIGHT, -2, DEFAULT_SCALE);
              
              translate([0, 0, -1])
                  cylinder(DEFAULT_HEIGHT + 2, 10, 10, $fn = 8);
              
              holeRotate(HOLE_ROTATION, -10, HOLE_SCALE_OFFSET) {
                  translate([0, 0, sin(10) * (-DEFAULT_HEIGHT)])  
                      cylinder(DEFAULT_HEIGHT * 5, MARBLE_RADIUS * 1.3, MARBLE_RADIUS * 1.3, $fn = 8);
              };
          }

          holeRotate(HOLE_ROTATION, 0, HOLE_SCALE_OFFSET) {
              cylinder(.5, MARBLE_RADIUS * 1.5, MARBLE_RADIUS * 1.5, $fn = 8);
          }

          difference() {
              cylinder(DEFAULT_HEIGHT, 11, 11, $fn = 12);
              translate([0, 0, -1])
                  cylinder(DEFAULT_HEIGHT * 1.5 + 2, 6.6, 6.6);
          }
      }
  }





  // BASE
  difference() {
    color("#339933")
    rotate([0, 0, 0]) 
      translate([15, -1, -WALL_THICKNESS - 1]) {
        difference() {
          union() {  
            // BASE
            difference() {
              // BASE SHAPE
              translate([2, 0, -29.5])
                cylinder(BASE_HEIGHT + 30, 50, 50, $fn = 3);
              
              // REMOVE TRIANGLE TOPS 
              translate([-30, 0, -1]) {
                rotate([0, 0, 30])
                  cube([60, 20, BASE_HEIGHT + 2]);
              }
              
            
              // BRACKET GEAR OPENING SLICER  
              translate([-14.75, 0, DEFAULT_HEIGHT + .5]) {
                rotate([0, 0, 30])
                  cube([GEAR_2_D - 28.5, GEAR_2_D, DEFAULT_HEIGHT + 3], center=true);
              }
                
              // BACK SLICER
              rotate([0, 0, 30])
                translate([-40, -20, -30.9])
                  cube([80, 200, 30]);
            }
          }
        
         // RIGHT MAIN SUPPORT SLICER
         translate([-5, 0, -2]) {
            union() {
              rotate([0, 0, 60])
                translate([3.25, -27, 0])
                  cube([GEAR_2_D, GEAR_2_D + 10, BASE_HEIGHT + 4]);
            }
          }
          

          // SIDE SUPPORT SLICERS
          rotate([0, 0, 30]) {
            translate([3.5, -20, -1])
              cube([30, 40, BASE_HEIGHT + 2]);
          
            translate([-49.25, -20, -1])
              cube([20, 40, BASE_HEIGHT + 2]);
          }
          
          rotate([90, 0, 30]) {
           // COMPASS HOLDER
           translate([-12.5, -10, 18])
             compassHolder(5, slicer = true);
            
           translate([20, 15, 17.1]) screwHole();
           translate([-33, 15, 17.1]) screwHole();
           translate([20, -24, 17.1]) screwHole();
           translate([-33, -24, 17.1]) screwHole();

            
          }
        }
      }
    
      // AXEL
      translate([0, 0, -10])
        cylinder(BASE_HEIGHT * 2, 2.5, 2.5, $fn = 36);
      

      // RIGHT BASE SLICER
      translate([87.5, 16.75, 0])
        rotate([0, 0, 60])
          cube([80, 80, 80], center = true);
      


      // BALL HOLE SLICER
      rotate([-10, 0, 30])
        translate([
          0, 
          (sin(10) * (-DEFAULT_HEIGHT) - GEAR_2_R) + (MARBLE_RADIUS * 1.3 / .5), 
          0
        ]) {
          cylinder(
            DEFAULT_HEIGHT * 5,
            MARBLE_RADIUS * 1.3, 
            MARBLE_RADIUS * 1.3, 
            $fn = 8
          );
          
        }

    // SLICER FOR JUST BRACKET
    *rotate([0,0,30])    
      translate([-12, 0, 0])
          cube([70, 90, 60], center = true);
    }


    angle = 15;  
   
    // BALL CATCHER
    rotate([-angle, 0, 30]) {
      translate([
        0, 
        (sin(angle) * (-DEFAULT_HEIGHT) - GEAR_2_R) + (MARBLE_RADIUS * 1.3 / .5), 
        -sin(angle) * MARBLE_RADIUS * 3
      ]) {
        
        rotate([-90, 0, 0]) 
            intersection() {
              translate([0, -25, -MARBLE_RADIUS * 1.8])
                bracket();
                      
              translate([0, -25, 0])
                rotate([90, 0, 0])
                  cylinder(
                    10,
                    MARBLE_RADIUS * 1.8, 
                    MARBLE_RADIUS * 2.4, 
                    $fn = 8
                  );
            }
          
        
          difference() {
            translate([0, 0, 7])
            cylinder(
            10,
            MARBLE_RADIUS * 1.8, 
            MARBLE_RADIUS * 1.8, 
            $fn = 8
          );

         translate([0, 0, 8])
           cylinder(
             12,
             MARBLE_RADIUS * 1.3, 
             MARBLE_RADIUS * 1.3, 
             $fn = 8
           );
            
            rotate([angle, 0, 0])
              translate([0, 0, 6.25])
              cube([MARBLE_RADIUS * 7, MARBLE_RADIUS * 7, MARBLE_RADIUS * 3], center = true);
          }
          
            difference() {
              translate([0, 0, 17])
              cylinder(
              10,
              MARBLE_RADIUS * 1.8, 
              MARBLE_RADIUS * 2.4, 
              $fn = 8
            );
              
            translate([0, 0, 16.9])
              cylinder(
                12,
                MARBLE_RADIUS * 1.29, 
                MARBLE_RADIUS * 1.9, 
                $fn = 8
              );
          } 
        }
      }

    // MOTOR HOLDER
    translate([DRIVE_GEAR_X - .5, 0, 2.75 - 9.25])
      rotate([0, 0, 30]) {
        translate([0, 0, -10]) {
          difference() {  
            translate([0, -4.36, 0])
              cube([18, 23, 14], center = true);
            
            cube([12.4, 10, 15], center = true);
          }
        }
      }
    }
    
    

  module base() {
    union() {
      translate([0, -15, 0]) circle(d = 50);
      translate([-25, -15, 0]) square([50, 60]);
      translate([0, 45, 0]) circle(d = 50);
    }
  }
  

curveBrackets = function (angle = 0) 
    abs(angle) == 90 ? [1, 0, 1] : 
    abs(angle) == 180 ? [1, 1, 1] :
    abs(angle) == 270 ? [1, 0, 1, 0, 1] :
    [];

ONLY_BRACKETS = false;
ONLY_RAILS = true;
PROJECTION = true;

module pathedWires(
  l = 10, 
  t = [0, 0, 0], 
  r = 0, 
  brackets = [0, 1, 0],
  onlyBrackets = ONLY_BRACKETS,
  onlyRails = ONLY_RAILS,
  projection = PROJECTION,
  $fn
) {
  translate(t) {
    rotate(projection ? 0 : [r, 0, 0]) {
      if (onlyRails == true || projection == true) {
        linear_extrude(projection ? cos(r) * l : l, $fn = $fn) {
          wireHolder(
            twoDee = true,
            projection = projection
          );
          
          mirror([90, 0, 0])
            wireHolder(
              twoDee = true,
              projection = projection
            );  
        }
      }
      
      if (onlyBrackets == true && projection == false) {
        count = len(brackets);  
        for (j = [0 : 1 : count - 1]) {
          if (brackets[j] != 0) {
            translate([
              0, 
              -MARBLE_RADIUS - WIRE_DIAMETER, 
              -1 + (l / (count - 1) * j)
            ]) 
              rotate([-90, 0, 0]) 
                bracket(ring = false);
          }
        }
      }
      
      translate([0, 0, l * cos(r) ]) 
        rotate([projection ? 0 : -r, 0, 0])
          children();
    }
  }
}

module curvedWires(
  d = 10, 
  angle = 90,
  t = [0, 0, 0], 
  r = [0, 0, 0], 
  brackets = false,
  onlyBrackets = ONLY_BRACKETS,
  onlyRails = ONLY_RAILS,
  projection = PROJECTION
) {    
  ry = angle < 0 ? angle : 0;
  bs = brackets == false ? curveBrackets(angle) : brackets;
  
  rotate([0,ry,0])
    translate([d + t[0], t[1], t[2]]) {
      if (onlyBrackets == false || projection == true) {
        rotate([270, 180, 0]) {
          rotate_extrude(angle = angle, $fn = 64)
            translate([d, 0, 0])
              wireHolder(
                twoDee = true,
                projection = projection
              );
        
          rotate_extrude(angle = angle, $fn = 64)
            mirror([90, 0, 0])
              translate([-d, 0, 0])
                wireHolder(
                  twoDee = true,
                  projection = projection
                );  
          }
        }
        
      rotate([0, angle, 0]) 
        translate([-d, 0, 0]) 
          rotate([0, ry, 0])
            children();    
      
      if (onlyBrackets == true && projection == false) {
        count = len(bs);  
        for (j = [0 : 1 : count - 1]) {
          if (bs[j] != 0) {
            let(theta = (angle < 0 ? -1 : 1) * angle / (count - 1) * j) {
              rotate([0, theta, 0])
                translate([
                  d * (angle < 0 ? 1 : -1), 
                  -MARBLE_RADIUS - WIRE_DIAMETER, 
                  0
                ]) 
                  rotate([-90, 0, 0]) 
                    translate([0, 1, 0])
                        bracket(ring = true, test = false);
            }
          }
        }
      }
  }
}

*translate([65,0,0]) {
  difference() {
    translate([0, 8.5, 0]) rotate([270, 0, 0]) bracket(h = 2, ring = true); 
    translate([-.125, .5, -0.1]) cylinder(h=2.2, r = MARBLE_RADIUS + 0.4 * 11);
  }
  
  translate([0, -6.25, 0]) rotate([270, 0, 0]) bracket(ring = true);
  translate([0, -6.4, 1]) rotate([90,0,0])  
    linear_extrude(26)
      square([6, 1.95], center = true);  
}

translate([-34.66,0,0]) {
  translate([0, 2, 0]) rotate([270, 0, 0]) bracket(h = 2, ring = true); 
  translate([0, -14.75, 0]) rotate([270, 0, 0]) bracket(ring = true);
  translate([0, -13.4, 1]) rotate([90,0,0])  
    linear_extrude(18)
      square([6, 1.95], center = true);  
}

*intersection() {
  group() {
    translate([0, 15, 10]) {
      group() {
        difference() {
          rotate([90, 0, 0]) translate([-15, -30, 4]) cube([69, 120, 1], center = true);
//
//          pathedWires(l = 15,              brackets = [])
//          curvedWires(d = 15, angle = 90)
//          pathedWires(l = 30,              brackets = [])
//          curvedWires(d = 20, angle = -180)
//          pathedWires(l = 60, r=6,         brackets = [])
//          curvedWires(d = 20, angle = -180)
          
          group() {
            //pathedWires(l = 60, r=8, brackets = [])
            curvedWires(d = 20, angle = -180)
            pathedWires(l = 60, r=8, brackets = [])
            curvedWires(d = 20, angle = -180)
            
            group() {
              curvedWires(d = 15, angle = 90, brackets = []);
            }
          }
        }
        
      }

    }                   
  }

  *translate([-35, 35, 60])
    rotate([90, 90, 0])
      cylinder(100, d = 25);
}

  

   * translate([0, -31.4, 60]) 
      rotate([90, 90, 0])
        translate([0, 85, 0])
          rotate([0,0,90])
            translate([-20, 0, -7])
                rotate([0,180,0])            
                  translate([0, 0, -8])
                    linear_extrude(26)
                      square([6, 2], center = true);  

*translate([0, -31.4, 60]) rotate([90, 90, 0]) {
  difference() {
    linear_extrude(4) {
      difference() {
        base();
        offset(-10) base();
      }
    }
    
    for (i = [30, 150])
      translate([0, -15, 4])
        rotate([0,0,i])
          translate([-20, 0, -7]) 
            screwHole();
    
    for (i = [-30, -150])
      translate([0, 45, 4])
        rotate([0,0,i])
          translate([-20, 0, -7]) 
            screwHole();
    
  }
  for (i = [0 : 90 : 180])
    translate([0, -15, 0])
      rotate([0,0,i])
        translate([-20, 0, -7]) 
          linear_extrude(11)
            difference() {
              square([16, 8], center = true);
              square([6, 2], center = true);
            }      
  
  for (i = [0 : -90 : -180])
    translate([0, 45, 0])
      rotate([0,0,i])
        translate([-20, 0, -7]) 
          linear_extrude(11)
            difference() {
              square([16, 8], center = true);
              square([6, 2], center = true);
            }
}
