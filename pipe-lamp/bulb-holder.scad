use <../marble-run/threads.scad>;

BULB_DIAMETER = 13;
BULB_HEIGHT = 30;
BULB_WIRE_HEIGHT = 9;

BASE_LENGTH = 7.6;
BASE_HEIGHT = 14.3;
BASE_WIDTH = 2.6;

ROD_HEIGHT = 110;
LIGHT_OFFSET = 30;
 
module bulb() {
  cylinder(BULB_HEIGHT, d= BULB_DIAMETER);
  translate([0, 0, BULB_WIRE_HEIGHT / -2]) cube([BASE_WIDTH, BASE_LENGTH, BULB_WIRE_HEIGHT], center = true);
}

*group() {
  translate([0, 0, BULB_WIRE_HEIGHT + BULB_HEIGHT + LIGHT_OFFSET]) bulb();
  translate([0, 0, BULB_HEIGHT + LIGHT_OFFSET]) rotate([180, 0, 0]) bulb();
}

module sliceTopper() {
  intersection() {          
    translate([0, 0, 8.5 + 2])
      rotate([90, 30, 0])
        translate([0, 0, -20])
          cylinder(h = 40, d = 11, $fn = 6);
    
    rotate([0, 0, 90]) cube([20, 8.5, BULB_HEIGHT * 1.4], center = true);
  }
}



difference() {  
  union() {
    translate([0, 0, 10])
      rotate([180, 0, 0]) 
        difference() {
          english_thread(
            diameter=1.315, 
            threads_per_inch=11.5, 
            length=1.2,   
            taper=1/16, 
            internal=false,
            test=$preview
          );
          
          translate([0, 0, 8]) cube([40, 40, 22], center = true);            
          translate([0, 0, 6]) cylinder(20, d=28);
      }
      
    translate([0, 0, -16]) linear_extrude(14) circle(d=17, $fn = 64);
    translate([0, 0, -2])
      linear_extrude(11 )
        difference() {
          circle(d=16.6, $fn = 64);
          offset(0.1) {
            difference() {
              circle(d = 17, $fn = 12);
              circle(d = 13.8, $fn = 12);
              rotate([0, 0, 93]) square([20, 8], center = true);
              rotate([0, 0, 87]) square([20, 8], center = true);
            }
            
            translate([-8, -1.2, 0]) square([16, 2.4]);
        }
    }
  }
  
  translate([0, 0, -40]) cylinder(50, d=8, $fn = 16);
}

*difference() {
  union() {
    difference() {
      union() {
        cylinder(ROD_HEIGHT, d = 17, $fn = 64);
        
        translate([0, 0, 10])
          rotate([180, 0, 0]) 
            difference() {
              english_thread (
                diameter=1.05, 
                threads_per_inch=14, 
                length=3/4, 
                taper=1/16, 
                internal = false, 
                test = true //$preview
              );
              
              translate([0, 0, 0]) cube([30, 30, 20], center = true);
          }
      }
      
     translate([0, 0, -10]) cylinder(ROD_HEIGHT * 1.2, d = 14, $fn = 64);
        
      
     translate([0, 0, (BULB_HEIGHT * 1.1 / 2) + BULB_HEIGHT + BULB_WIRE_HEIGHT + LIGHT_OFFSET]) {
        cube([20, 8.5, BULB_HEIGHT * 1.1 - 8.5], center = true);
                 sliceTopper();
          mirror([0,0,1]) sliceTopper();
        rotate([0, 0, 90]) {
          cube([20, 8.5, BULB_HEIGHT * 1.1 - 8.5], center = true);
          sliceTopper();
          mirror([0,0,1]) sliceTopper();
        }
      }
      
      translate([0, 0, LIGHT_OFFSET + (BULB_HEIGHT * 1.1 / 2)]) {
        cube([20, 8.5, BULB_HEIGHT * 1.1 - 8.5], center = true);
        sliceTopper();
        mirror([0,0,1]) sliceTopper();
        
        rotate([0, 0, 90]) {
          cube([20, 8.5, BULB_HEIGHT * 1.1 - 8.5], center = true);
          sliceTopper();
          mirror([0,0,1]) sliceTopper();
        }
      }
    }

    translate([0, 0, ROD_HEIGHT])
      difference() {
        intersection() {
          sphere(d = 17.2);
          cylinder(h = 17, d = 17, $fn = 64);
        }
        
        sphere(d = 15);
    }
  }

  rotate([0, 0, 45]) 
    translate([7.75, 0, LIGHT_OFFSET]) {
      translate([0,0, BULB_HEIGHT + BULB_WIRE_HEIGHT / 2]) 
        rotate([0, 90, 0]) 
          translate([-1.2, 0, -3]) 
            cylinder(6, d = 3, $fn = 16);
    
      translate([.4, 0, 0]) cylinder(BULB_HEIGHT * 1.2, d = 2.4, $fn = 32);
    }
  
  rotate([0, 0, -135]) 
    translate([7.75, 0, LIGHT_OFFSET]) {
      translate([0, 0, BULB_HEIGHT + BULB_WIRE_HEIGHT / 2]) 
        rotate([0, 90, 0]) 
          translate([-1.2, 0, -3]) 
            cylinder(6, d = 3, $fn = 16);
      
      translate([.4, 0, 0]) cylinder(BULB_HEIGHT * 1.2, d = 2.4, $fn = 32);
    }
}