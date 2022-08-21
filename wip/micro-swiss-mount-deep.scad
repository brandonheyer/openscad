$fn = 32;

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
    }
  }

group() {
  difference() {
    color("red")
      import("C:/Users/Brandon/openscad/BantaMount-Base-CR10-MicroSwiss.stl", 1, 4
      );
    
    translate([-48.001, 5.99, 31.9])
      cube([64, 13, 47]);
    
    translate([-40, -12, 31])
      cube([32, 50, 50]);

    translate([-15, 5.99, 67])
      rotate([0, 90, 90])   
        translate([-1, 1, -6])
          cylinder(h = 20, d = 3.4);
  
    translate([11, 18, 31.9])
      cube([5, 3.5, 50]);
  }

  translate([15, 5.99, 67])
    rotate([0, 90, 90]) {
      mirror([0, 1, 0]) 
        upright();
    }
}

difference() {
  union() {
    difference() {
      color("red")
        import("C:/Users/Brandon/openscad/BantaMount-Base-CR10-MicroSwiss.stl", 1, 4
        );
      
      translate([-15.999, 5.99, 31.9])
        cube([32, 20, 47]);
      
      translate([-0, -12, 31])
        cube([32, 40, 50]);

      translate([-15, 5.99, 67])
        rotate([0, 90, 90])   
          translate([-1, 1, -6])
            cylinder(h = 20, d = 3.4);
      
      translate([-16, 15.1, 37])
        rotate([90, 0, 180])
          translate([13, 0.5, 0]) 
            cylinder(h = 3, d = 7, $fn = 6);
    }
    
    translate([-43, 12, 32])
      cube([24, 6, 22]);
    
    translate([-38, 12, 32])
      cube([20, 6, 27]);
    
    difference() {
      translate([-28.8, 12, 58])
        cube([9, 6, 9]);
        
      translate([-28.8, 11.9, 68])
      rotate([0, 90, 90])
        cylinder(h = 8, d = 18, $fn = 128);
    }
    
    translate([-20, 16.8, 32])
      cube([38, 1.2, 8]);
   
    translate([-38, 18, 54]) {
     translate([0, -3, 0])
       rotate([0, 45, 0]) 
         cube([10, 3, 22]);
      
     rotate([90, 0, 0])
       cylinder(h = 6, d = 10, $fn = 64);
     
     translate([4.6, -3, -5.3])
       rotate([0, -40.5, 0])
         cube([12, 3, 12]);
 
     translate([23, 0, -8])
        rotate([90, 0, 0])
          difference() {
            cylinder(h = 3, d = 52, $fn = 256);
            
            rotate([0, 0, -20])
              translate([17, 10.5, 2.1])
                cube([47, 20, 5], center = true);
          
            translate([-15, -15, 2.1])
              cube([100, 50, 5], center = true);
            
            rotate([0, 0, -40])
              translate([6.6, 24.2, 2.1])
                cube([47, 20, 5], center = true);
          }
    }
  }
  
  translate([-16, 15, 37])
    rotate([90, 0, 180]) {
      translate([23, 18, -6]) 
        cylinder(h = 12, d = 3.8);

      translate([19.2, 1.8, -6]) 
        cylinder(h = 10, d = 3.8);     
     
      translate([19.2, 1.8, -3.1]) 
        rotate([0, 0, 90])
          cylinder(h = 2, d = 7, $fn = 6);
      
      translate([13, 0.5, -6]) 
        cylinder(h = 10, d = 3.8);
      
      translate([13, 0.5, 0.1]) 
        rotate([0, 0, 90])
          cylinder(h = 3, d = 6.6, $fn = 6);
    }
}

translate([-15, 5.99, 67])
  rotate([0, 90, 90])
    upright();
 
translate([0, 6, 61])
  rotate([90, 0, 0])
    linear_extrude(6)
      difference() {
        translate([0, -8, 0]) 
          circle(d = 51, $fn = 128);

        translate([0, -8, 0])
          circle(d = 34, $fn = 128);
          
        translate([20, -62, 0])
          rotate([0, 0, 60])
            square([61.1, 40]);
            
        translate([-20, -62, 0])
          mirror([1, 0, 0])
            rotate([0, 0, 60])
              square([61.1, 40]);
      }



*translate([-16, -8, 37])
  rotate([90, 0, 180])
    color("green") 
      difference() { 
        translate([17, 10, 0])
          rotate([0, 0, -45]) 
            scale([1, 1, 1]) 
              cylinder(h = 2, d = 30);
        
        translate([0, 20, -.1])
          cylinder(h = 2.2, d = 3);
        
        translate([5, 26.5, -.1]) 
          cylinder(h = 2.2, d = 3.8);
        
        translate([19.2, 1.8, -.1]) 
          cylinder(h = 2.2, d = 3.8);
        
        translate([23, 18, -.1]) 
          cylinder(h = 2.2, d = 3.8);
        
        
      translate([13, 0.5, -.1]) 
        cylinder(h = 10, d = 3.8);
    }