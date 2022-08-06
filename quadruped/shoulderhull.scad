include <constants.scad>;
include <servo.scad>;
include <screws.scad>;


module shoulderHull(screwHole = 2.5) {  
  difference() {
    union() { 
      color("green")
       difference() {
         $fn = 64;
         
          hull() {
            translate([-10, -3, 0]) 
              rotate([0, 0, -15]) 
                hull() {
                  servo(1, 30);
                
                  mirror([0, 0, 1]) 
                    servo(1, 18, false, false);
               
                  translate([0, 14, 0]) { 
                    translate([22, 0, 14])
                      rotate([90, 0, 0])
                        cylinder(24, d = 19);
                    
                    translate([-13, -2, -11])
                      rotate([90, 0, 0])
                        cylinder(24, d = 34);
                        
                    translate([-24, -2, 16])
                      rotate([90, 0, 0])
                        cylinder(24, d = 10);
                    
                    translate([22, -2, -19])
                      rotate([90, 0, 0])
                        cylinder(24, d = 14);
                        
                  }
                }
              
            translate([0, -5.75, -.5])   
              cylinder(
                S_BOX[2] + 5.5 + .1, 
                d = 32,
                center = true
              );
          }
          
        translate([-10, -3, 0]) 
          rotate([0, 0, -15]) {
            scale([1.01, 1.01, 1])
              servo(10, 22);
            
            mirror([0, 0, 1]) scale([1.01, 1.01, 1])
              servo(6, 11, false, false);        
          } 
      }
          
      color("blue") 
        difference() {
          hull() {
            $fn = 64;
            hull() {
              translate([-5, 4, 7]) 
                rotate([5, -10, 0]) {
               
                  translate([-1, 36, 18])
                    rotate([90, 0, 0])
                      cylinder(22, d = 25.4);
                  
                  translate([-3, 40, -13])
                    rotate([90, 0, 0])
                      cylinder(30, d = 36); 
                  
                  translate([-18, 36, -14])
                    rotate([90, 0, 0])
                      cylinder(24, d = 28);
                      
                  translate([-21, 38, 16])
                    rotate([90, 0, 0])
                      cylinder(26, d = 20);
                
                  translate([-30, 30, 0])
                    rotate([90, 0, 0])
                      cylinder(16, d = 12);  
                }
            }
          
              
            rotate([0, 80, 0])
              translate([.15, 28.3, -10.2])   
                cylinder(
                  S_BOX[2] + 8 + 2.2, 
                  9, 
                  16, 
                  center = true
                );
        }
        
        translate([-5, 4, 7]) 
          rotate([5, -10,  0]) {
            translate([-9, S_BOX[1] * 1.02 + 3, 0])
              rotate([0, 90, 180])
                scale([1.01, 1.01, 1])
                  servo(10, 1, false, false);
            
             mirror([1, 0, 0])
               translate([9, S_BOX[1] * 1.02 + 3, 0])
                 rotate([0, 90, 180]) 
                   scale([1.01, 1.01, 1])
                     servo(6, 1);        
          } 
        }
   
        hull() {
          $fn = 64;
     
           translate([-15, 28.3, -2.6])  
              rotate([0, 80, 0])     
                translate([0, 0, -6])
                  cylinder(38, 12, 16, center = true);
            
            translate([-.33, -5.75, -2.05])   
              cylinder(S_BOX[2] + 12.4, d = 32, center = true);
          }
    }
    
    translate([-10, -3, 0]) 
      rotate([0, 0, -15]) {
        scale([1.01, 1.01]) {
          servo(10, 24);
        }
        
        mirror([0, 0, 1]) scale([1.01, 1.01, 1]) {
          servo(6, 11, false, false);
          servo(10, 7, false, false); 
        }      
      }
        
    translate([-5, 4, 7]) 
      rotate([5, -10,  0]) {
        translate([-9, S_BOX[1] * 1.02 + 3, 0])
          rotate([0, 90, 180])
            scale([1.01, 1.01, 1]) {
              servo(6, 11, false, false);
              servo(10, 7, false, false);
            }
            
         mirror([1, 0, 0])
           translate([9, S_BOX[1] * 1.02 + 3, 0])
             rotate([0, 90, 180]) 
               scale([1.01, 1.01, 1])
                 servo(10, 24);
      }
      
      group() {
        screwSlicer(
          [-14, -12, -23.6],
          [90, 0, -15],
          15,
          t2 = [0, 0, -5],
          sd = screwHole,
          sh = 14
        );
        
        screwSlicer(
          [10, -12, -23.6],
          [90, 0, -15],
          15,
          t2 = [0, 0, 1],
          sd = screwHole,
          sh = 14
        );
      }
       
      group() {
        screwSlicer(
          [12.4, -17, 17.8],
          [90, 0, -15],
          15,
          t2 = [0, 0, -4],
          sd = screwHole,
          sh = 14
        );
        
        screwSlicer(
          [-36, -5, 17],
          [90, 0, -15],
          15,
          t2 = [0, 0, -4],
          sd = screwHole,
          sh = 14
        );
      }

    
    screwSlicer(
      [-17, 32, 33],
      [85, 0, -180],
      10,
      sd = screwHole,
      sh = 15
   );

    group() {   
       screwSlicer(
          [-37, 30, 4],
          [85, 0, -180],
          18,
          t2 = [0, 0, 1],
          sd = screwHole,
          sh = 12.4
       );
      
      screwSlicer(
        [-34, 29, -15],
        [85, 0, -180],
        18,
        t2 = [0, 0, 3],
        sd = screwHole,
        sh = 12.4
     );
    }
 
    group() {      
      screwSlicer(
        [7, 32, -13],
        [85, 0, -180],
        
        18,
        t2 = [0, 0, 1],
        sd = screwHole,
        sh = 15
      );
    
      screwSlicer(
        [8, 30, 17],
        [85, 0, -180],
        18,
        t2 = [0, 0, 1],
        sd = screwHole,
        sh = 15
      );

    }
  }
}

module angledShoulder() {
  PARTS = [
    "SHOULDER_1",
    "SHOULDER_2",
    "SHOULDER_3"
  ];

  CURR_PART = 1;

  screwHole = CURR_PART == PARTS[1] ? 2.5 : SCREW_D;
  
  // ANGLED SHOULDER
  difference() {
    shoulderHull(screwHole); 
    
    // inner joint cover remover
    *translate([0, 42, 0]) 
      cube([80, 30, 150], center = true);
    
    // inner joint cover remover
    if (CURR_PART == PARTS[2]) {
      translate([0, -13, 0]) 
        rotate([5, 0, 0])
          cube([90, 80, 150], center = true);
    }
    
    if (CURR_PART == PARTS[1]) {
     translate([0, -13, 0]) 
        rotate([5, 0, 0]) 
          translate([0, 80, 0])
            cube([90, 80, 150], center = true);
    
      translate([-40, -118.6, 0])
        rotate([0, 0, -15])
          translate([0, 80, 0])
            cube([90, 80, 150], center = true);
    }
    
    if (CURR_PART == PARTS[0]) {
      translate([-40, -118, 0])
        rotate([0, 0, -15])
          translate([0, 160, 0])
            cube([90, 80, 150], center = true);
    }
      
    translate([-5, 4, 7]) 
      rotate([5, -10,  0]) {
        translate([-9, S_BOX[1] * 1.02 + 3, 0])
          rotate([0, 90, 180])
            scale([1.01, 1.01, 1]) {
              servo(6, 11, false, false);
              servo(10, 7, false, false);
            }
            
         mirror([1, 0, 0])
           translate([9, S_BOX[1] * 1.02 + 3, 0])
             rotate([0, 90, 180]) 
               scale([1.01, 1.01, 1])
                 servo(20, 24);
              
      }
  }
}

*angledShoulder();
