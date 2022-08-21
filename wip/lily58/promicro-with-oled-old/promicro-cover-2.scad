w = 33;
d = 18.2;
h = 1.5 + .1;

CORNER_RADIUS = 2;

HEADER_D = 3;
HEADER_H = 0.2 * 8;

OLED_OFFSET = 0.8;
OLED_BW = 25.3 + OLED_OFFSET;
OLED_BD = 26.1 + OLED_OFFSET;
OLED_H = 0.2 * 30;

BASE_W = w + (2 * 1.25) + 0.4;
BASE_D = d + 0.4;
BASE_H = (0.2 * 3) + HEADER_H;

BR = 3;

SIDE_T = 1.6;
SIDE_LONG = w + .6 + .5 + 0.4;
SLTX = SIDE_T - 0.2;

PCB_W = d + 0.4;

OLED_SW = 25.3;
OLED_SD = 16.8;

OLED_B = [OLED_BD + 9.2, OLED_BW, OLED_H];
OLED_S = [OLED_SD + 0.6, OLED_SW, 8];
OLED_B2 = [
  OLED_B[0] + 4.15, 
  OLED_B[1] + 0.9, 
  0.2 * 3
];

MIC_D = 8;
MIC_D_RING = 11;

CLIP_HEIGHT = 5.4;
OLED_TY = (OLED_BW - BASE_W) / 2 + 1.35 - OLED_OFFSET;  
w1 = w + 0.35;

WALL_NOTCH_X = 5.4;
WALL_NOTCH_Y = d - 2.6 - 0.8;
WALL_POLY_NO_CENTER = [
  [-1.2, -4],        
  [w1, -4],        
  [w1, d + 3.2],
  [WALL_NOTCH_X, d + 3.2],  
  [WALL_NOTCH_X, WALL_NOTCH_Y],    
  [-1.2, WALL_NOTCH_Y]
];

module clip(d) {
  rotate([90, 0, 0])
    translate([-1.8, 0, -d])
      linear_extrude(d)
        polygon([          
          [2.2, h - 3],
          [2.2, h * 1.25],
          [0, h * 1.25],          
          [0, h - 0.4]
        ]);
  }
  
module oledSlicer(extraH = 0) {
  translate([
      OLED_OFFSET / 2, 
      OLED_OFFSET / 2,
      0.2 * 4 - extraH
    ])
      cube([
        OLED_BD - OLED_OFFSET,
        OLED_B[1] - OLED_OFFSET,
        0.2 * 8 + extraH
      ]);
}

module cornerSphere(r, x1 = 0, r1 = 90) {
  translate([0, 0, x1]) rotate([0, r1, 0]) sphere(r);
}


$fn = 32;
mins = min(WALL_POLY_NO_CENTER);
maxes = max(WALL_POLY_NO_CENTER);
rad = 2;

module roundedEdge(
  tx = 0, 
  ty = 0, 
  rot = 0, 
  h = 0, 
  sphereOne = true, 
  sphereTwo = true, 
  r = CORNER_RADIUS
) {
  
  rx = is_list(rot) ? rot[0] : 0;
  ry = is_list(rot) ? rot[1] : rot;
  rz = is_list(rot) ? rot[2] : 0;

  translate([tx, ty, r])
    rotate([rx, ry, rz])
      union() {
        linear_extrude(h)
          circle(r);
        
        if (sphereOne == true) {
          cornerSphere(r);
        }
        
        if (sphereTwo == true) {
          cornerSphere(r, h);
        }
      }
}

module roundedFrame() {
  roundedEdge(mins[0], mins[1], 90, maxes[0] - mins[0]);
  roundedEdge(WALL_NOTCH_X, maxes[1], 90, maxes[0] - WALL_NOTCH_X);
  roundedEdge(mins[0], WALL_NOTCH_Y, 90, WALL_NOTCH_X - mins[0], true, false);
  roundedEdge(maxes[0], mins[1], [0, 90, 90], maxes[1] - mins[1], false, false);
  roundedEdge(mins[0], mins[1], [0, 90, 90], WALL_NOTCH_Y - mins[1], false, false);
  roundedEdge(WALL_NOTCH_X, WALL_NOTCH_Y, [0, 90, 90], maxes[1] - WALL_NOTCH_Y, false, false);
}
 

projection()
 rotate([90, 0, 0]) import("./lily58-bottom.stl");

intersection() {
  if (false && !$preview) {
    translate([
      -SIDE_T - 0.05 + 2.475, 
      OLED_TY, 
      -OLED_H
    ])        
    // OLED BASE
    translate([w + 0.825, 4.35, -3])          
      mirror([1, 0, 0])        
        linear_extrude(10, convexity = 4)
          offset(r = 1.2, $fn = 32) offset(-1.2) polygon(WALL_POLY_NO_CENTER);
           
  }

  union() {      
    // OLED COVER
    translate([
      -SIDE_T - 0.05 + 2.475, 
      OLED_TY, 
      -OLED_H
    ])
        difference() {    
          // OLED BASE
          translate([w + 0.825, 4.35, -3])          
            union() {
              mirror([1, 0, 0]) {              
                translate([0, 0, 2])
                  linear_extrude(5, convexity = 4)
                    offset(r = CORNER_RADIUS)
                      polygon(WALL_POLY_NO_CENTER);
                
                linear_extrude(9, convexity = 4)
                  polygon(WALL_POLY_NO_CENTER);
                
                roundedFrame();
                
                translate([0,0, 5]) 
                  roundedFrame();
              }
            }
          
            translate([w + 0.825, 4.35, -3])          {
              mirror([1, 0, 0]) 
                translate([0,0,0.2 * 3])
                  linear_extrude(9, convexity = 4)
                    polygon(WALL_POLY_NO_CENTER);
          }
          
          // OLED CUTOUT
          translate([-.25, 0, 0]) {
            // MAIN CUTOUT          
            translate([OLED_BD - OLED_SD - 3.8, 0.4, -7])
              cube(OLED_S);
            
            translate([OLED_BD - 3.21, (d - 1 + 0.4) / 2, -3.4])
              cube([3.4, 8.5, 2]);            
          }
          
                  
          // MIC SLICERS        
          translate([
            w - SIDE_T - 3 + MIC_D_RING,
            3 + (d - SIDE_T * 2),
            0.2 * 8
          ])
            rotate([0, 90, -90]) 
              translate([0, 1, 6])
                cylinder(d = MIC_D, h = d, $fn = 64);
        }
        
      // PCB CLIPS        
      translate([w + 2.45, -4, -CLIP_HEIGHT]) {
        translate([0, 0, 3.8]) {
          difference() {
            color("blue") clip(PCB_W + 0.2);
            
            translate([-2, -.5, 1.6]) 
              cube([10, PCB_W + 2, 3]);
          }
          
        }
      
        color("red") clip(PCB_W + 0.2);
      }

      // PCB BASE      
        union() {           
          // BASE CLIP
          translate([1.6, d + 3, -CLIP_HEIGHT])      
            rotate([0,0,180])clip(BASE_D + 7.2);
          
          // SIDES
          translate([0.5, 0.8, -8.4]) {              
            cube([0.8, 10, 11 - 4]);         
          }
        }  

        
        // RESET SWITCH
        *translate([20, -6, -1]) 
          rotate([0, 90, 90])
            cylinder(d = 4, h = 3, $fn = 32);
      }
    
}