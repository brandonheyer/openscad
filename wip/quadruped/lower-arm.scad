include <servo.scad>;

module lowerArmOld(ph = 10, screws = true, j1r = -8) {
  translate([-7, 1, -12]) 
    servoMount(
      d = screws ? 11 : 5, 
      h = screws ? 11 : 10, 
      taper = screws ? 16 : 14, 
      screws = screws
    );
 
  difference() {
    hull() {
      intersection() {
        translate([-7, 0, -1])
          rotate([screws ? -12 : -8, 0, 0])
            cylinder(
              screws ? 10 : 5, 14,
              screws ? 19 : 18, 
              center = true
            );

        translate([-7, 1, -12])
          servoMount(
            d = 5, 
            h = 15, 
            taper = screws ? 21 : 18.5, 
            screws = screws
          );
      }
       
      translate([2, 48, -2.1])
        rotate([-10, 0, 0])
          cylinder(6, d = 17, center = true);
    }
    
    if (screws) {
      translate([-7, 1, -8.3])
        cylinder(18, 12, 11);
    }
  }
    
  hull() {
    translate([2, 48, -2.1])
        rotate([-10, 0, 0])
          cylinder(6, d = 17, center = true);
      
    translate([2, 70, -6.5])
        rotate([-10, 0, 0])
          cylinder(5, d = 15.6, center = true);
  }
   
  difference() {
    group() {
      hull() {
        translate([2, 70, -6])
          rotate([-10, 0, 0])
            cylinder(4, d = 15.6, center = true);
        
        translate([3.5, 130, -33.75])
          rotate([0, 0, 0])
            cylinder(4, d = 11, center = true);
      }
      
      translate([3.5, 130, -33.75])    
        hull() {      
          cylinder(6, d = 11, center = true);
     
          translate([0, 10, 0])
            cylinder(6, d = 11, center = true);   
      }
    }
    
    translate([3.5, 131, -40.5]) {
      translate([0, 0, 7]) 
        cylinder(9, d = 7);
      
      cylinder(14, d = 3.2);
    }
    
    translate([3.5, 140, -40.5]) {
      translate([0, 0, 7]) 
        cylinder(6, d = 7);
      
      cylinder(14, d = 3.2);
    }
     
  }    
}


module lowerArmPairOld() {
  $fn = 32;
  h = S_BOX[2] + 19;
  ph = 10;
                      
  difference() {
    translate([0, 0, 5 + (h + ph) / 2])
      lowerArmOld(screws = false);
    
    translate([8.9, -30, 0])
      cube([5, 180, 70]);
  }

  difference() {
    translate([0, 0, (h + ph) / -2])
      mirror([0, 0, 1])
        lowerArmOld(ph = 10, j1r = -12);

  rotate([0, 0, 1])
    translate([11, -30, -50])
      cube([5, 180, 70]);
  } 
}

module lowerArm(screws = true, j1r = -8) {
  translate([-7, 1, -12]) 
    servoMount(
      d = screws ? 10 : 5, 
      h = 6, 
      taper = screws ? 10 : 9, 
      screws = screws,
      fn = 128
    );
 
  difference() {
    $fn = $preview ? 32 : 128; 
    
    hull() {
      intersection() {
        translate([-7, 1, -3])
          cylinder(
            screws ? 10 : 8,
            screws ? 11 : 10,
            screws ? 14 : 10, 
            center = true
          );

        translate([-7, 1, -16])
          servoMount(
            d = 6, 
            h = 12, 
            taper = screws ? 21 : 18.5, 
            screws = screws,
            fn = $fn
          );
      }
       
      translate([2, 48, -2])
        rotate([-10, 0, 0])
          cylinder(6, d = 17, center = true);
    }
    
    if (screws) {
      translate([-7, 1, -6]) {
        cylinder(5, 11, 8.9);
      
        translate([0, 0, -5])
          cylinder(6, 8.9, 8.9);
      }
    }
  }
    
  hull() {
    translate([2, 48, -2])
        rotate([-10, 0, 0])
          cylinder(6, d = 17, center = true);
      
    translate([2, 70, -7])
        rotate([-10, 0, 0])
          cylinder(5, d = 14, center = true);
  }
   
  difference() {
    group() {
      hull() {
        translate([2, 70, -7])
          rotate([-10, 0, 0])
            cylinder(5, d = 14, center = true);
        
        translate([-2, 131, -33.75])
          rotate([0, 0, 0])
            cylinder(6, d = 10, center = true);
      }
      
      translate([-2, 131, -33.75])    
        hull() {      
          cylinder(6, d = 10, center = true);
     
          translate([-2, 9, 0])
            cylinder(6, d = 10, center = true);   
      }
    }
    
    translate([-2, 131, -40.5]) {
      translate([0, 0, 7]) 
        cylinder(9, d = 7);
      
      cylinder(14, d = 3.2);
    }
    
    translate([-4, 140, -40.5]) {
      translate([0, 0, 7]) 
        cylinder(6, d = 7);
      
      cylinder(14, d = 3.2);
    }
     
  }    
}

module lowerArmPair() {
  $fn = 32;
  h = S_BOX[2] + 19 + 10;
                      
  *translate([0, 0, 5 + h / 2])
    lowerArm(screws = false);
    
   
   translate([0, 0, h / -2])
     mirror([0, 0, 1])
      lowerArm(j1r = -12); 
}

*%lowerArmPairOld();
lowerArmPair();