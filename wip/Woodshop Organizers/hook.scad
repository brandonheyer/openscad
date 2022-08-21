$fn = 32;
WIDTH = 6;
LENGTH = 4.75;

module pegSection() {
  $fn = 32;
  rotate([0, 0, 90])
      offset(r = 2.35)
        offset(-2.35) 
          square([WIDTH, LENGTH]);
}

module pegBend(angle = 90, tx = 1) {
  rotate_extrude(angle = angle)
    translate([-tx, 0, 0])
      pegSection();
}

difference() {
  union() {
    rotate([90, 0, 90])
      linear_extrude(1)
        pegSection();

    translate([0, 2, 0]) {
      pegBend(tx = 2);
     
      translate([-LENGTH - 1 - 1, 0, 0]) {
        rotate([90, 0, 180])
          linear_extrude(5)
            pegSection();
        
        translate([-1, 5, 0]) {
          *rotate([0, 0, 180])                 
            pegBend();
          
          *translate([0, 1, 0]) 
            rotate([90, 0, 270])
              linear_extrude(18)
                pegSection();
          
          translate([1 - 21, 1 + LENGTH / 2, 0]) 
            rotate([90, 0, 0]) {
              difference() {
                translate([0,0,4.375])
                linear_extrude(11)
                  pegSection();
               
                translate([-LENGTH / 2, -1, 6])
                  rotate([90, 90, 180])
                    linear_extrude(10) 
                      polygon([
                        [0, 0],
                        [-10, 3],
                        [-10, -3] 
                      ]);
              }
              
              difference() {
                union() {
                  translate([-0.1, WIDTH / 2, 12.4])     
                    sphere(1.5);
                  
                  translate([-LENGTH + 0.1, WIDTH / 2, 12.4])
                    sphere(1.5);
                }
                
                translate([-LENGTH / 2, -1, 6])
                  rotate([90, 90, 180])
                    linear_extrude(10) 
                      polygon([
                        [0, 0],
                        [-10, 3],
                        [-10, -3] 
                      ]);
              }
              
              translate([2, WIDTH, LENGTH - .375])
                rotate([90, 0, 0])
                  pegBend(tx = 2);
            }
              
            
            
          *translate([-20, LENGTH + 4 + 1, 0]) {
            rotate([0, 0, 270])
              pegBend(180, 4);
            
            translate([0, LENGTH + 4, 0]) 
              rotate([90, 0, 90])
                linear_extrude(5)
                  pegSection();
          }
        }
      } 
    }

    translate([-32.5, 7, 0])
      cube([30.5, LENGTH + 2, WIDTH]);
  }
  
  mountSlicer(40, -38, 6.4); 
}

module mountSlicer(l = 20, tx = 0, ty = 0, cs = 2.8) {
  group() {
    translate([tx, ty + sqrt(2)*cs, - sqrt(2)*cs/2])
      rotate([45,0,0])cube([l, cs, cs]);

    translate([tx, ty + sqrt(2)*cs, WIDTH - sqrt(2)*cs/2])
      rotate([45,0,0]) cube([l, cs, cs]);  
  }
}

module fullMountSlicer(s = [20, 6.75, 6], tx = 0, ty = 0) {
  difference() {
    translate([tx, ty, 0])
      cube(s);
    
    translate([tx - 0.1, ty - 0.6, 0])
      mountSlicer(s[0] + 0.2, tx, ty);
  }
}


!difference() {
  translate([0.1, -3, -2]) 
    cube([24, LENGTH + 4.5, 10]); 

  fullMountSlicer();
}