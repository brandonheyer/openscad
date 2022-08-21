$fn = 32;
base = "C:/Users/Brandon/openscad/BantaMount-Base-CR10-MicroSwiss.stl";

module upright() {
  $fn = 64;
    
  difference() {
    linear_extrude(12.01) {
      intersection() {
        translate([-6, 0])
          square(6);
        
        circle(d = 10);
      }
      
      intersection() {
        translate([-1, -6])
          square(6);
        
        translate([-1, 1]) 
          circle(d = 10, $fn = 80);
      }
      
      polygon([
        [0, 5],
        [-5, 0],
        [-5, -4],
        [-1, -4],
        [2.47, -2.595],
        [6.1, 1],
        [35, 1],
        [35, 5],
        
      ]);
    }
    
    translate([-1, 1, -6])
      cylinder(h = 20, d = 3.4);
    
    translate([-1, 1, -6]) 
      cylinder(h = 20, d = 6.6, $fn = 6);
  }
}


difference() {
  color("green")
    import(base, 1, 4);
  
  // 2mm deeper
  translate([0, 25.99, 65])
    cube([100, 40, 70], center = true);
  
  translate([-15, 5.99, 67])
    rotate([0, 90, 90]) 
      translate([-1, 1, -1]) 
        cylinder(h = 4, d = 6.6, $fn = 6);

  translate([17, 5.99, 67])
    rotate([0, 90, 90]) 
      translate([-1, 1, -1]) 
        cylinder(h = 4, d = 6.6, $fn = 6);
}

color("blue")
  translate([0, -10, 0]) {
  difference() {
    import(base, 1, 4);
    
    // 2mm deeper
    translate([0, -1.99, 65])
      cube([100, 40, 70], center = true);

    translate([11, 18, 31.9])
      cube([5, 3.5, 50]);
    
    translate([12, 18, 50])
      cube([12, 12, 4]);
  }
}


color("red") {
  translate([-3.5, -9.91, 0])
    difference() {
    union() {
      translate([-43, 12, 32])
        cube([24, 6, 22]);
      
      translate([-38, 12, 32])
        cube([21.5, 6, 27]);
      
      difference() {
        translate([-24.8, 12, 58])
          cube([9, 6, 9]);
          
        translate([-24.8, 11.9, 68])
          rotate([0, 90, 90])
            cylinder(h = 8, d = 18, $fn = 128);
      }
      
     
      translate([-18, 16, 32])
        cube([38, 2, 8]);
      
      translate([3.4, 16, 39.5])
        rotate([0, 90, 90])
          difference() {
            cylinder(h = 2, d = 73, $fn = 128);
            
            translate([-10, 0, 0])
            cylinder(h = 5, d = 34, $fn = 4, center = true);
            
            translate([10, -39, 0])
              cube([100, 40, 10], center = true);
            translate([20, 0, 0])
              cube([60, 100, 10], center = true);
          
              translate([-8.9 - 19.5, -16.2, -.4])
                cube([7, 6.2, 5], center = true);
        
              translate([-8.9 - 19.5, 15.6, -.4])
               rotate([0, 0, 60]) cube([4, 6.2, 5], center = true);
                    
            
              translate([-8.9 - 18.5, 16.5, -.4])
               rotate([0, 0, 90]) cube([5, 5, 5], center = true);
            
              translate([-8.9 - 19.5, 15, -.4])
               rotate([0, 0, 120]) cube([5, 6.4, 5], center = true);
            }
            
      translate([-38, 18, 54]) {
       rotate([90, 0, 0])
         cylinder(h = 6, d = 10, $fn = 64);
       
      }
    }
    
    translate([-16, 15, 37])
      rotate([90, 0, 180]) {
        translate([23, 18, -6]) 
          cylinder(h = 12, d = 3.8);

        translate([17.6, 3, -6]) 
          cylinder(h = 10, d = 3.8);     
      
        translate([17.6, 3, -3.1]) 
          rotate([0, 0, 0])
            cylinder(h = 2, d = 6.8, $fn = 6);
        
        translate([13, 0.5, -6]) 
          cylinder(h = 10, d = 3.8);
        
        translate([13, 0.5, 0.1]) 
          rotate([0, 0, 90])
            cylinder(h = 3, d = 6.6, $fn = 6);
      }
  }
}

color("yellow")
  group() {
    translate([-15, 5.99, 67])
      rotate([0, 90, 90])
        linear_extrude(2.1)
          projection() 
            upright();

    translate([15, 5.99, 67])
      rotate([0, 90, 90])
        mirror([0, 1, 0]) 
          linear_extrude(2.1)
            projection()
              upright();
  }