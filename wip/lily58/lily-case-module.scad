module lilyScrewSlicer(t = [0, 0, 0], ch = 3.1) {
  translate(t) {
      translate([0, 0, -0.05]) linear_extrude(1.25) 
        circle(3, $fn = 32);
    
      translate([0, 0, -ch]) linear_extrude(ch) 
        circle(1.5, $fn = 32);
        
      translate([0, 0, -1.4]) cylinder(1.4, 1.5, 3.1, $fn = 32);
  }
}

module lilyCase(showTop = false, convexity = 4) {
  rotate([90, 0, 0]) {
    if (showTop) {
      translate([-44.8, -3, 110])
        import(
          "./originals/lily58-top.stl", 
          convexity = convexity
        );
    }
    
    union() {
      translate([180, -3, 109.26])
        intersection() {      
          mirror([1,0,0]) {
            import(
              "./originals/lily58-bottom.stl", 
              convexity = convexity
            );        
          }
          
          translate([-180, 14, -110])
            rotate([90, 180, 0]) 
              linear_extrude(15)
               polygon([          
                  [-2, -25.3],              
                  [8, -25.3],
                  [10, 36],
                  [-26.9, 39],
                  [-27.1, 26.4],
                  [-4, 26.6],              
                  [3.4, 24],            
                  [4, 19],  
                  [4, -20],
                  [-2, -20]
              ]);      
        }  
     
      rotate([90, 180, 0]) {       
        difference() {
          linear_extrude(3)
            polygon([                
              [4.5, -24],
              [-32, -10],           
              [-32, 28.8],
              [-3.9, 28.8],
              
              [4.5, 25.1],
              [4.5, 19.1],  
              
          ]);
          
          translate([-6.4, 14.6, 2.1])
            linear_extrude(1.1) 
              circle(9.2, $fn = 64);                  
        }
      }
      
      
      difference() {
        translate([-44.95, -3, 110]) 
          import("./bottom-corner-filled.stl", convexity = 4);        
        translate([-10, -3.1, -36])
          cube([37, 10, 40]);
        
        translate([-10, -3.1, -12]) 
          cube([10, 10, 36.5]);
      }
    }
  }
}