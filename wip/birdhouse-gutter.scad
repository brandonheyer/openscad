WIDTH = 131;

module gutter() {
  difference() {
    union() {
      linear_extrude(20) 
        polygon([
          [-2,-2],
          [-10,-2],
          [-10, 24],
          [0,24],
          [185 / 2, 24 / 2],
          [6 * 185 / 8, 24 / 2.5],
          [185, 24 / 3.4],
          [185, -2],
          [185 / 2, 4],
          [-2, 15]
        ]);
      
      // BACK
      difference() {
        translate([-16, -2, -11]) {
          translate([0, 0, 0.2]) hull() {
            cube([14, 0.1, 30.8]);
              translate([0, 23.9, 0]) 
                cube([15.8, 0.1, 30.8]);
          }

          hull() {
            translate([0, 23.9, 0]) 
              cube([15.8, 0.1, 31]);
            
            translate([0, 27.9, 0]) 
              cube([16, 0.1, 31]);
          }
        }
         
        translate([-10, 25.3, 5]) 
          rotate([0, 0, -7.3]) 
            translate([-100, 0, 0]) 
              cube([200, 5, 20]);
      }

     // FIN
     translate([0, 0, -11]) 
       linear_extrude(14)
         polygon([
          [-0.1,23],
          [-0.1,26],
          [185,4],
          [185,1],
        ]);
    }
      
    translate([0, 29.55, 10]) 
      rotate([7.3, 90, 0]) 
        translate([0,0,-13])
          cylinder(107, d = 23, $fn = 6);
    
    translate([91.8, 17.74, 10]) 
      rotate([3, 90, 0]) 
        cylinder(100, d = 23, $fn = 6);
  }

  // NOTCH
  translate([-12, -2, -41.3])
    hull() {
      cube([10, 0.1, 31]);
        translate([0, 23.9, 0]) 
          cube([11.8, 0.1, 31]);
    }
}

module backGutter() {
  // BASE
  difference() {
    // FOUNDATION
    translate([4, 11.7, 0])
      hull() {
        cube([14, WIDTH - 1 - 22 - 0.4, 0.1]);
        translate([0, 0, 28.4]) 
          cube([16, WIDTH - 1 - 22 - 0.4, 0.1]);
      }
     
    //cube([15, WIDTH - 1 - 22, 28.5]);
    
    // NICHE
    translate([7.8, 11, -0.1])
      cube([18, 31 + 0.2, 24 + 0.3]);
    
    // NICHE
    translate([7.8, 89, -0.1])
      cube([18, 31 + 0.2, 24 + 0.3]);
    
    // TRIANGLE CUTOUT
    *translate([-1, 65.5, -32])
      rotate([0, 90, 0])
        scale([4, 3, 1])
          cylinder(h = 24, d = 24, $fn = 6);
  }
  
  overhang = 23;
  xMin = 28.5;
  xMax = xMin + 8;
  yMinBase = 4.5;
  yMaxBase = WIDTH - yMinBase - 22;
  yMinTop = yMinBase - overhang;
  yMaxTop = yMaxBase + overhang;
  
  difference() {
    union() {
      translate([4, 11, 0]) 
        rotate([90, 90, 90])
          linear_extrude(16)
            polygon([
              [-xMin + 0.2, yMaxBase + 15],
              [-xMax, yMaxTop],
              [-(xMax + 4), yMaxTop],
              [-(xMax + 4), yMinTop - 3],
              [-xMax, yMinTop - 3],
              [-xMin + 0.2, yMinBase - 15]
            ]);
       
      translate([4.7, 1.5 - 13 + 5, 28 + 5])
        rotate([0, -4, 0])
          cube([30, yMaxTop - yMinTop - 4, 6]);
    }
      
    translate([13, 23, 47.75]) {
      translate([0, 86 + 0.5, 0]) 
        rotate([0, 90, -90]) 
          cylinder(88, d = 24, $fn = 6);

      topGutterSideSlicer();

      mirror([0, 1, 0]) 
        translate([0,  -WIDTH + 46, 0])
          topGutterSideSlicer();
          
    }
  }
}

module topGutterSideSlicer() {
  rotate([-10, 95, -90]) 
    cylinder(45, d = 24, $fn = 6);
}
  
*translate([-20, 0.5, -2])
  backGutter();

*group() {
  translate([0, 1, 0])
  rotate([90, 0, 0]) 
    gutter();

  translate([0, WIDTH, 0])
    mirror([0, 1, 0])
      rotate([90, 0, 0]) 
        gutter();
}

// SIDE GUTTERS FOR PRINTING
group() {
  gutter();
  translate([0, -15, 0]) mirror([0, 1, 0]) gutter();
}