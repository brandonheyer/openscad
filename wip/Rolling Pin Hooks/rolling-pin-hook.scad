module rollingPinHook(thickness = 15, base = false, holes = false) {
  difference() {
    if (base) {
      translate([17.125, -39, -2 + 9.5])
        scale([1.02, 1.02, 1])
          cube([38.25,10,19], center = true);
    }

    linear_extrude(thickness)
      import("rolling-in-hook-3.svg");

    if (holes) {
      rotate([-90, 0, 0]) {
        translate([6.5, thickness / -2, -39]) {
          
          // Lower Screw Hole      
          group() {
            translate([0, 0, -6])
              cylinder(40, d = 3.7, $fn = 16);
            
            translate([0, 0, 2]) 
              cylinder(3, d = 3.7, $fn = 16);   
           
            translate([0, 0, 5.75]) 
              cylinder(40, d = 8, $fn = 16);   
          }
          
          // Upper Screw Hole      
          group() {
            translate([20, 0, 0]) {
              translate([0, 0, -6])
                cylinder(40, d = 3.7, $fn = 16);
              
              translate([0, 0, 2]) 
                cylinder(3, d = 3.7, $fn = 16);   
             
              translate([0, 0, 5.75]) 
                cylinder(50, d = 8, $fn = 16);   
            }
          }
        }    
      }
    }
  }
}

rollingPinHook();