LAYER_SIZE = 0.28;
BAR = 60; // base = 28, bars = 61
MAX = 20; // base = 39, bars = 59
PEG_DIAMETER = 8;
HOLE_DIAMETER = PEG_DIAMETER + .25;
HOLE_RADIUS = HOLE_DIAMETER / 2;
TXS = [
  HOLE_RADIUS + 1.75, 
  HOLE_RADIUS + 6.75,
  HOLE_RADIUS + 9.75, 
  HOLE_RADIUS + 14.75,
];

STRAIGHT_OFFSET = -46;
I_MAX = 2;
R_MAX = 3;
COLORS = ["blue", "yellow", "green"];


//RZS = [-24, 6, 40, 56];
RZS = [0, 26, 50, -20];


module midCross() {
  cylinder(d = PEG_DIAMETER, h = 3, $fn = 64, center = true);
  cube([11, 3, 3], center = true);
  rotate([0, 0, 90]) cube([11, 3, 3], center = true);
}

module disc(d = 5) {
  difference() {
    union() {
      translate([0, 0, .5]) cylinder(1, d, d + 0.5, center = true, $fn = 64);
      translate([0, 0, -.5]) cylinder(1, d, d, center = true, $fn = 64);
    }
    
    scale([1.08, 1.08, 1.1]) midCross();
  }
}

module rod(tx = 0, gripper = true, extraBar = 5, holeRecess = false, skip = 0) {
  gripperY = -16 - tx;
  alternateGripperY = (skip * 10) + tx + 12 + MAX + (MAX + 10) - HOLE_DIAMETER / 2;
  width = alternateGripperY - gripperY;
  
  difference() {
   union() {
      translate([0,  width / 2 + gripperY, 0]) {
        translate([0, 0, -.5])
          cube([16, width, 4], center = true);
        
        translate([0, width / 2, -2.5]) {
          cylinder(d=16, h=8, center = true, $fn = 32);
          
          translate([0,0,-6.5])
            cylinder(5, 5, 8, center = true, $fn = 64);
        }
        
        translate([0, width / -2, -2.5]) {
          cylinder(d=16, h=8, center = true, $fn = 32);
                    translate([0,0,-6.5])
                      cylinder(5, 5, 8, center = true, $fn = 64);
        }
        
        translate([0, width / 2, -5]) rotate([90, -30, 0]) {
              translate([1.5 / 2, 1.5 * sqrt(3) / 2, 0]) 
                  rotate([0, 0, -7.5]) 
                    difference() {
                      cylinder(width, 8.655, 8.655, $fn = 8); 
                      translate([4, 6, 50]) rotate([0, 0, -22.5]) cube([20, 10, 120], center = true);
          }
        }
  
      }
      
      group() {
        if (gripper) {
          translate([0, gripperY, -1.5]) {
            cylinder(d = 16, h = 10, center = true, $fn = 64);
          }
          
          translate([0, alternateGripperY, -1.5])  
            cylinder(d = 16, h = 10, center = true, $fn = 64);
        
        }
      }
    }
    
    for (y = [(skip * 10) : 10 : MAX + (skip * 10)]) {
      translate([0, y + (gripper ? 0 : tx), 0]) {
        cylinder(d = HOLE_DIAMETER, h = 16, center = true, $fn = 64);
      
        if (holeRecess) {
          translate([0,0,1.3]) cylinder(d = 12, h = 2, center = true, $fn = 64);
        }
      }
    }
  }
}

module baseLabel(i, r, t =  [0, -1.2, -3]) {
  if (!$preview) {
    color("pink") 
      translate(t)
        linear_extrude(1) 
          text(chr(i + 65, r + 65), 2.6, "Helvetica:style=bold", halign="center");
  }
}

module baseHoles() {
  difference() {
    for (i = [0 : 1 : I_MAX]) {
      for(r = [0 : 1 : R_MAX]) {
        rotate([0, 0, RZS[r]]) {
          translate([0, 10 + TXS[r] + (i * 10), 0]) {
            color(COLORS[i])
              rotate([0, 0, 22.5])
                cylinder(d = HOLE_DIAMETER, h = 5, center = true, $fn = 8);
            
              translate([STRAIGHT_OFFSET, 0, 0]) {
                color(COLORS[i]) 
                  rotate([0, 0, 22.5])
                    cylinder(d = HOLE_DIAMETER, h = 5, center = true, $fn = 8);
                
                *baseLabel(i, r);
              }
            
            *baseLabel(i, r);
          }
        }
      }
    }
  }
}

*translate([10, 10 , -3]) cylinder(h = 6, d = PEG_DIAMETER, $fn = 8);


// BASE
*group() {
  difference() {
    color("gray") 
hull() {
          h = 5;
          translate([0, 0, -1.5]) {
            cylinder(h, 58, 58, center = true, $fn = 64);
            translate([-20, 14, 0]) cylinder(h, 55, 55, center = true, $fn = 64);
            
 rotate([0,0,-30]) translate([-70, -50, 0])cube([120, 100, 2]);

              translate([-73, -3, -h/4]) cylinder(h / 2, 20, 20, center = true, $fn = 32);
              translate([-35, 65, -h/4]) cylinder(h / 2, 20, 20, center = true, $fn = 32);
              translate([57, 12, -h/4]) cylinder(h / 2, 20, 20, center = true, $fn = 32);
              translate([18, -55, -h/4]) cylinder(h / 2, 20, 20, center = true, $fn = 32);
          }
        }
    
    translate([0,0,-.5]) baseHoles();
  }

  translate([0, 0, 2.5]) {
    translate([0,0,4]) cylinder(d = 8, h = 6, $fn = 64, center = true);
    midCross();
    translate([0,0,8]) cylinder(2, 4, 3, $fn = 64, center = true);
  }
}



// BARS
group() { 
  *rod(4, extraBar = 18, holeRecess = true);
  *rod(9, extraBar = 41, holeRecess = true);
  rod(2, extraBar = 41, holeRecess = true, skip = 1);
  translate([30, -5, 0])  rod(7, extraBar = 41, holeRecess = true, skip = 1);
}
// DISCS
group() {
  // 20mm
  group() {
    *rotate([0,0, RZS[0]]) translate([0, 0, 2.5]) disc(10);
    *rotate([0,0, RZS[2]]) translate([0, 0, 2.5]) disc(18);
  }

  // 25mm
  group() {
    *rotate([0,0, 0]) translate([0, 0, 2.5]) disc(15);
    *rotate([0,0, 0]) translate([0, 0, 2.5]) disc(23);
  }

  // 30mm
  group() {
    *rotate([0,0, RZS[0]]) translate([0, 0, 2.5]) disc(20);
    *rotate([0,0, RZS[3]]) translate([0, 0, 2.5]) disc(28);
  }
}