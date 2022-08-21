include <constants.scad>;
include <servo.scad>;
include <screws.scad>;

module plateScrews(h, w, l, d ) {
  $fn = 32;
 
  // PCB Screws
  translate([0, -70, -64]) {   
    // Common
    translate([-49 / 2, 0, 0])
      cylinder(d = SCREW_D, h = 20);
    
    translate([49 / 2, 0, 0])
      cylinder(d = SCREW_D, h = 20);
     
    // Pi 3 B+
    translate([-49 / 2, 58, 0])
      cylinder(d = SCREW_D, h = 20);
   
    translate([49 / 2, 58, 0])
      cylinder(d = SCREW_D, h = 20);
 
    // Arduino Mega
    translate([-49 / 2, 75, 0])
      cylinder(d = SCREW_D, h = 20);
    
    translate([49 / 2, 81, 0])
      cylinder(d = SCREW_D, h = 20);
  }
    
  // Mount Spots
  translate([0, 0, -64]) {
    $fn = 32;
    offset1 = w / 2 + d / 2 - 4;
    
    // Left
    mountingScrews([offset1, 0, 0]);
    
    // Right
    mountingScrews([-offset1, 0, 0], [1, 0, 0]);
  
    // Middle
    mountingScrews(cross = true);
    
    // Front
    mountingScrews([0, -75, 0], [1, 1, 0]);
   
    // Back
    mountingScrews([0, 60, 0], [-1, 1, 0]);
   
    // Spine
    for (y = [25, -25, -50, -75])
      translate([0, y, 0])
        cylinder(d = SCREW_D, h = 20);
  }
}

SIMPLE = true;

!shoulderBracket(false);

module shoulderBracket(screws = true, simple = SIMPLE) { 
  translate([-68, 68, 0]) {
    servoMount(
      d = 10, 
      h = 4, 
      taper = 16, 
      screws = simple ? false : true,
      center = simple ? false : true,
      fn = simple ? 8 : 64
    );

    translate([0, 0, 4]) {
      difference() {
        if (screws != "only") {
          union() {
            rotate([0, 0, 45]) {
              $fn = simple ? 16 : 128;
              cylinder(h = 4, d = 32);
            
              translate([0, -13, 2])
                cube([32, 26, 4], center = true);
              
              translate([0, -48, -64])
                cube([32, 96, 4], center = true);
          
              translate([0, -96, -66])
                cylinder(h = 4, d = 32);  
              
              // Top Curve
              translate([-16, -58, 0])
                rotate([0, 90, 0])  
                  translate([0, 32, 0])
                    quarterBend(48, 32, 4);
              
              translate([0, -48, -31])    
                cube([32, 4, 22], center = true);
            
              // Bottom Curve
              translate([-16, -46, -58])
                rotate([90, 0, 0]) 
                  rotate([0, 90, 0])
                    translate([0, 16, 0])
                      quarterBend(48, 32, 4);
              
              translate([16, -66, -58])
                rotate([90, 0, 180]) 
                  rotate([0, 90, 0])
                    translate([-16, 16, 0])
                      quarterBend(48, 32, 4);
             
             translate([0, -24, -64]) {                
                translate([0, 24, -2])
                  cylinder(h = 4, d = 32);
              
                translate([0, 24, 6.5])
                  rotate([0, 180, 0])
                    servoMount(
                      d = 6, 
                      h = 4, 
                      taper = 16, 
                      screws = false,
                      center = simple ? false : true,
                      fn = simple ? 8 : 64
                    );
              }      
            }
            
            *translate([32 * cos(45), -42, -64])
              cube([32, 84, 4], center = true);
          }
          
        }
          
        rotate([0, 0, 45]) {
          // For Screws
          $fn = 32;
        
          translate([0, 0, -0.1]) 
            cylinder(h = 5, d = 28, $fn = simple ? 16 : 64);
        
                    
          if (!simple && (screws == true || screws == "only")) {
            translate([0, -45.9, -41])
              rotate([90, 0, 0])
                for(y = [-10 : 20 : 10])
                  translate([y, 0, 0])
                    for(x = [0 : 20 : 20])
                      translate([0, x, 0])
                        cylinder(10, d = SCREW_D);
            
            translate([0, -21, -66.1]) {          
              translate([10, 0, 0]) 
                cylinder(10, d = SCREW_D);
             
              translate([-10, 0, 0])
                cylinder(10, d = SCREW_D);
            }
               
            translate([0, -21, -0.1]) { 
              translate([10, 0, 0])
                cylinder(10, d = SCREW_D);
              
              translate([-10, 0, 0])
                cylinder(10, d = SCREW_D);
            }
                          
            translate([0, -80, -66.1]) {
              translate([10, 0, 0])
                cylinder(15, d = SCREW_D);
                
              translate([-10, 0, 0])
                cylinder(15, d = SCREW_D);      
            }
            
            translate([0, -100, -66.1]) {
              translate([10, 0, 0])
                cylinder(15, d = SCREW_D);
                
              translate([-10, 0, 0])
                cylinder(15, d = SCREW_D);   
            }
          }
        }
      }
    }
  }
}

module quarterBend(d, h, t, simple = SIMPLE) {
  $fn = simple ? 16 : 128;
  translate([d / 2 - 4, 0, 0])
    difference() {
      cylinder(h = h, d = d);

      translate([0, 0, -0.1]) {
        cylinder(h = h + 0.2, d = d - (t * 2));
                
        translate([-d, 0, 0])
          cube([d * 2, d, h + 0.2]);
        
        translate([0, -d, 0])
          cube([d, d * 2, h + 0.2]);
      }
    }
} 

module brackets(screws = true) {
  color("#eebb00") {
    w = 36;
    h = 74;
    
    translate([-w / 2, h / 2, 0])
      rotate([0, 0, 30])
        shoulderBracket(screws);
    
    translate([w / 2, h / 2, 0])
      rotate([0, 0, -120])
        shoulderBracket(screws);
   
    translate([-w / 2, -h / 2, 0])
      rotate([0, 0, 90])
        shoulderBracket(screws);
    
    translate([w / 2, -h / 2, 0])
      rotate([0, 0, -180])
        shoulderBracket(screws);  
  }
}

module screwMount(h, d = 0.4 * 4, slicer = true) {
  difference() { 
    if (!slicer) {
      cylinder(h = h, d = SCREW_D + d, $fn = 32);
    }
    
    translate([0, 0, -0.1])
      cylinder(h = h + 0.2, d = SCREW_D, $fn = 32);
  }
}

module mountingScrews(
  t = [0, 0, 0], 
  m = [0, 0, 0], 
  y = 10, 
  d = SCREW_D, 
  h = 20, 
  cross = false
) {
  translate(t) mirror(m) {
    cylinder(d = d, h = h);
  
    translate([0, -y, 0])
      cylinder(d = d, h = h);
        
    translate([0, y, 0])
      cylinder(d = d, h = h);
  
    translate([-y, 0, 0])
      cylinder(d = d, h = h);
    
    if (cross) {
      translate([y, 0, 0])
        cylinder(d = d, h = h);  
    }
  }
}

*group() {
  translate([-.25, -5.6, 25.4]) {
      union() {
        rotate([0, 0, 0])
          shoulderBracket();
       
        translate([0, -168, 0])
          mirror([0, 1, 0]) 
            rotate([0, 0, 0])
              shoulderBracket();
      }   
    
  }
}

*group() {
  h = 6;
  w = 38;
  l = 98;
  d = 45;
  
  difference() {
    translate([0, -7, -61.99])
      linear_extrude(h + 5)
        minkowski() {
          square([w, l], center = true);
          circle(d = d, $fn = 128);
        }
    
    brackets(false);
    brackets("only");
    plateScrews(h, w, l, d);   
  }
  
  *brackets(true);

  *translate([0, -30 - 13.5, -43])
    color("purple")
      cube([49, 58, 20], center = true);
  //cube([56, 85, 20], center = true);
  
  
  *translate([0, 0, -20])
    color("blue")
      cube([65, 110, 16], center = true);

}

module taperScrewSpacer() {
  cylinder(d = 8, h = 7.2);

  translate([0, 0, 7])
    cylinder(7, 4, 16);
}

// Basic Spacer
module spacer(h = 4, d = 8.4, nut = false) {
  innerD = SCREW_D + 0.2;
  $fn = $preview ? 32 : 128;
 
  difference() {
    cylinder(d = d, h = h);
    
    translate([0, 0, -0.2]) {
      cylinder(h = h + 0.4, d = innerD);
      
      if (nut) {
        translate([0, 0, 2.799])
          cylinder(min(h - 2.8, 2.8), 3.2, innerD / 2, $fn = 6);
        cylinder(2.8, 3.2, 3.2, $fn = 6);
      }
    }
  }
}

*spacer(h = 10, nut = true);

group() {
  $fn = $preview ? 32 : 128;
  d = SCREW_D + 0.2;
  h = 10;

  // Common
  translate([-49 / 2, 0, 0])
    spacer(20, 5);
      
  translate([49 / 2, 0, 0])
    spacer(20, 5);
  
  difference() {
    translate([0, 0, 1.5])
      union() {
        cube([50, 8, 3], center = true);
        translate([-49 / 2, 0, 0]) 
          cylinder(h = 3, d = 8, center = true);
        translate([49 / 2, 0, 0]) 
          cylinder(h = 3, d = 8, center = true);
      }
      
    translate([-49 / 2, 0, -0.2])
      cylinder(h = h + 0.4, d = SCREW_D + 0.2);   

    translate([49 / 2, 0, -0.2])
      cylinder(h = h + 0.4, d = SCREW_D + 0.2);  
      
    translate([-7.5, 0, -0.2])
      cylinder(h = h + 0.4, d = SCREW_D + 0.2);   

    translate([7.5, 0, -0.2])
      cylinder(h = h + 0.4, d = SCREW_D + 0.2); 
  }
    
  // Pi 3 B+
  translate([5, 10, 0])
    spacer(30, 5);
 
  translate([-5, 10, 0])
    spacer(30, 5);


  translate([-12, 10, 0])
    spacer(10, 5);

  translate([12, 10, 0])
    spacer(10, 5);

  translate([19, 10, 0])
    spacer(10, 5);

  translate([-19, 10, 0])
    spacer(10, 5); 
}

// Gyro Mount
*group() {
  d = SCREW_D + 0.2;
  $fn = 32;
  difference() {
    union() {
      taperScrewSpacer();
      
      translate([20, 0, 0])
        taperScrewSpacer();
    }
   
    translate([0, 0, -0.2])
      cylinder(h = 2.8, d = 6.1, $fn = 6);
    
    translate([10 + 7.5, 6, 0]) {
      cylinder(d = d, h = 20);
      cylinder(d = 6, h = 12);
    }
    
    translate([10 - 7.5, 6, 0]) {
      cylinder(d = d, h = 20);
      cylinder(d = 6, h = 12);
    }
    
    translate([10, 0, -0.1])
      cylinder(d = 6, h = 12);
    
    translate([-10, -23, -0.1])
      cube([40, 20, 20]);
    
    translate([-10, 9.4, -0.1])
      cube([40, 10, 20]);
    
    translate([-23, -13, -0.1])
      cube([20, 40, 20]);
  
    translate([23, -13, -0.1])
      cube([20, 40, 20]);
   
    translate([10, 0, -1])
      mountingScrews(m = [1, -1, 0], d = d);
  }
}