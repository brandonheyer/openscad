WIDTH = 131;
DIAMETER = 31; // 1.25"
DPAD = 5.8;
BOTTOM_X = -35;
Y_MAX = 53;

X_STOPS = [8, 14, 10, 16, 8];
X_MULTS = [1.5, 1.4, 1.2, 1, 1];

outerDiameter = DIAMETER + DPAD;
outerRadius = outerDiameter / 2;
holeY = 27;
holeZ = 40;
triangleY = (20 * sqrt(3) / 2);
  increase = 0.4;

*difference() {
linear_extrude(height = 10, convexity = 3) {
      polygon([
        [0, 0],
        [10, 0],
        [10, 53],
        [0, 57],
        [-17, 59],
        [BOTTOM_X, 60],
        [BOTTOM_X, 50],
        [0, 35],
        [-10, 23],
        [BOTTOM_X, 19],
        [BOTTOM_X, 15],
        [-17, 14]
      ]);
    }
    
    translate([-70, 0, 0]) cube([50, 80, 80]);
    
  }

intersection() {
difference() {
  union() {
    linear_extrude(height = WIDTH, convexity = 3) {
      polygon([
        [0, 0],
        [10, 0],
        [10, 53],
        [0, 57],
        [-17, 59],
        [BOTTOM_X, 60],
        [BOTTOM_X, 50],
        [0, 35],
        [-10, 23],
        [BOTTOM_X, 19],
        [BOTTOM_X, 15],
        [-17, 14]
      ]);
    }

    translate([-2, 0, 0]) {
      translate([11, -0.5 + holeY, holeZ])
        hull() {
          translate([0, 0, 25.5]) cube([2, Y_MAX, WIDTH], center = true);
          
          translate([X_STOPS[0], 0, 0])
            rotate([30, 0, 0]) 
              rotate([0, 90, 0])
                cylinder(2, d = outerDiameter * X_MULTS[0], , $fn = 6);
        }
        
      translate([11, -0.5 + holeY, holeZ])
        hull()
          translate([X_STOPS[0], 0, 0]) {
            rotate([30, 0, 0]) 
              rotate([0, 90, 0])
                cylinder(2, d = outerDiameter * X_MULTS[0], , $fn = 6);
            
            translate([X_STOPS[1], 0, 0])
              rotate([18, 0, 0]) 
                rotate([0, 90, 0])
                  cylinder(2, d = outerDiameter * X_MULTS[1], , $fn = 10);
          }
      
      translate([11, -0.5 + holeY, holeZ]) translate([X_STOPS[0], 0, 0])
        hull()
          translate([X_STOPS[1], 0, 0]) {
              rotate([18, 0, 0]) 
                rotate([0, 90, 0])
                  cylinder(2, d = outerDiameter * X_MULTS[1], , $fn = 10);
            
            translate([X_STOPS[2], 0, 0]) {
              rotate([45, 0, 0]) rotate([0, 90, 0]) 
                cylinder(2, d = outerDiameter * X_MULTS[2], $fn = 16);
            }
          }

      translate([11, -0.5 + holeY, holeZ]) 
        translate([X_STOPS[0], 0, 0]) 
          translate([X_STOPS[1], 0, 0])
            hull()  
              translate([X_STOPS[2], 0, 0]) {
                rotate([45, 0, 0]) rotate([0, 90, 0])               
                  cylinder(2, d = outerDiameter * X_MULTS[2], $fn = 16);
                
              translate([X_STOPS[3], -2, 0])
                rotate([0, 90, 0]) cylinder(2, d = outerDiameter * X_MULTS[3], $fn = 24);
          }
          
      translate([11, -0.5 + holeY, holeZ]) 
        translate([X_STOPS[0], 0, 0]) 
          translate([X_STOPS[1], 0, 0])
            translate([X_STOPS[2], 0, 0])
            hull()  
              translate([X_STOPS[3], -2, 0]) {
                rotate([45, 0, 0]) rotate([0, 90, 0])               
                  cylinder(2, d = outerDiameter * X_MULTS[3], $fn = 24);
                
              translate([X_STOPS[4], -2, 0])
                rotate([0, 90, -5]) cylinder(0.1, d = outerDiameter * X_MULTS[4], $fn = 48);
          }
    }
  }

  translate([70, -0.5 + holeY - 4.5, holeZ]) 
    rotate([0, 90, -7])
      cylinder(75, d = DIAMETER, center = true, $fn = 128);

  translate([-35, 20, holeZ]) 
    rotate([90, 0, 0])
      scale([1, 1.33, 1])
        cylinder(40, d = 60, $fn = 3, center = true);
  
  translate([0, holeY - 0.5, holeZ]) 
    rotate([0,270,0]) translate([0,0,-50]) {
      $fn = 128;
      
      hull() {
        cylinder(h = 1, d = DIAMETER, center = true);
        translate([0, 0, 32]) cylinder(h = 0.1, d = DIAMETER, center = true);
      }
      
      hull() {
        translate([0, 0, 32]) cylinder(h = 0.1, d = DIAMETER, center = true);
        translate([0, DIAMETER * (increase - 0.1), 60]) 
          scale([1.5, 1]) 
            cylinder(h = 0.1, d = DIAMETER * (1 + increase), center = true);
      }
      
      hull() {
        translate([0, DIAMETER * (increase - 0.1), 60]) 
          scale([1.5, 1]) 
            cylinder(h = 0.1, d = DIAMETER * (1 + increase), center = true);
        
        translate([0, DIAMETER * (increase - 0.1), 100]) 
          scale([1.5, 1])
            cylinder(h = 0.1, d = DIAMETER * (1 + increase), center = true);
      }
    }
  }
  
  translate([20, 0, 10]) cube(60);
}