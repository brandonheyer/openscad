STEP = 20;

difference() {
  union() {
    linear_extrude(50, twist = 45, slices = 8, $fn = 32, convexity = 20)
      union() {
        for (i = [0 : STEP : 360 - STEP])
          rotate([0, 0, i])
            translate([20, 0, 0])
              circle(d = 10, $fn = 4);
      }
    
      *cylinder(1, d = 40);
  }
    
  translate([0, 20, -5])
    hull() {
      cube([1, 30, 1], center = true);  
      translate([0, 0, 55]) cube([30, 30, 1], center = true);
    }
  }      
