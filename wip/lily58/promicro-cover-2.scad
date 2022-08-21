include <./lily-case-module.scad>;
include <./cover-edge-piece.scad>;
 
PROMICRO_BOX = [18.4, 33.1, 1.9];

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
w1 = w + 0.35 + 13;

WALL_NOTCH_X = 5.4;
WALL_NOTCH_Y = d - 2.6 - 0.8;
WALL_POLY_NO_CENTER = [
  [-1.2, -4],        
  [w1, -4],        
  [w1, d + 3.2],  
  [-1.2, d + 3.2]
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
  roundedEdge(mins[0], maxes[1], 90, maxes[0] - mins[0]);  
  roundedEdge(maxes[0], mins[1], [0, 90, 90], maxes[1] - mins[1], false, false);
  roundedEdge(mins[0], mins[1], [0, 90, 90], maxes[1] - mins[1], false, false);
}
 


PROMICRO_SQUARE = [PROMICRO_BOX[0], PROMICRO_BOX[1]];
USB_BOX = [11, 10, 4];
PROMICRO_T = [4.2, -9, 0];

*rotate([90, 0, 0])  
  translate([-44.9, -3, 110])
    import(
      "./originals/lily58-top.stl", 
      convexity = 4
    );

difference() {
  color("#33dccc") {
    difference() { 
      rotate([90, 0, 0])
        union() {
          translate([180, -3, 109.25]) {
            intersection() {      
              mirror([1,0,0]) {
                import(
                  "./originals/lily58-top.stl", 
                  convexity = 4
                );
              }
              
              translate([-180, 14, -110])
                rotate([90, 180, 0]) 
                  linear_extrude(15)
                   polygon([              
                      [8, -15],
                      [10, 36],
                      [-16.4, 39],
                      [-20, 24],
                      [-5, 24],              
                      [3.4, 24],            
                      [4, 19],  
                      [4, -15],
                  ]); 
            }
            
            translate([-296.65, 0, -51.5])
              import("./cover-corner-piece.stl");
            
            translate([-224.31, 0, -228.65]) {
              
              rotate([0, 270, 0])
                translate([136.15, 4, -60])
                linearEdge(15);
              
                rotate([0, -90, 0])
                  import("./cover-corner-piece.stl");
            }
           
            translate([-160.48, 4, -136.23]) {
              linearEdge(40);
              
              translate([-1, 0, 0])
                rotate([-90, 0, 0])
                  difference() {
                    rotateEdge(100, 1);
                    cube([10, 0, 0]);
                  }
            }
            
          }
          translate([0, 4.5, -20])
            cube([20, 3, 24]);
         
          translate([-5, 6, -26])
            cube([25, 3, 43]);
        }
    
      translate([-0.4, 32, 0.2 * 18]) 
        rotate([90, 0, 0])  {
          $fn = 64;

          translate([0, 0, 4.3]) {
            cylinder(20, d = 10);
            translate([0, 0, -4])
              cylinder(5, d = 8.2);  
          }   
        }
      
       translate([
        PROMICRO_T[0] + 
          (PROMICRO_BOX[0] - USB_BOX[0]) / 2 - 8,    
        PROMICRO_BOX[1] + PROMICRO_T[1] + 1.9, 
        -2
       ])
        cube([
          USB_BOX[0] + 8,
          USB_BOX[1],
          USB_BOX[2] * 2
        ]);
    }
    
    translate([22.2, 27, 3.8])
      cylinder(d = 3.5, h = 3, $fn = 32);
    
    translate([19.945, 24.2, 3.8])
      cube([4, 2.8, 2.2]);
    
    translate([19.945, 25.6, 3.8])
      cube([3, 4.2, 2.2]);
    
    translate([00, -17, 0])
      cylinder(d = 5, h = 6, $fn = 32);
  }
 
  translate([22.2, 27, 0])
    cylinder(d = 3, h = 7.4, $fn = 32); 
    
  
  translate([00, -17, -0.1])
    cylinder(d = 3, h = 7, $fn = 32);
  
  lilyCase(false);
}

*color("#cccd33") 
      union() {
        difference() {
          union() {
            lilyCase(false); 
            
            translate(PROMICRO_T)        
              difference() {      
                translate([0, -1, 0])
                linear_extrude(PROMICRO_BOX[2] * 2)
                  offset(delta = 1.2)
                    square([
                      PROMICRO_SQUARE[0] + 1.8,
                      PROMICRO_SQUARE[1] + 5.6
                    ]);
                            
                  
                linear_extrude(PROMICRO_BOX[2] + 0.1)
                  offset(delta = -.8)
                    square(PROMICRO_SQUARE);

                translate([0, 0, PROMICRO_BOX[2]])
                  linear_extrude(PROMICRO_BOX[2] + 0.1)
                    square(PROMICRO_SQUARE);
                
                translate([PROMICRO_BOX[0] - 1.3, 1.2, 0])  
                  cube([
                    5, 
                    PROMICRO_BOX[1] - 2.4, 
                    PROMICRO_BOX[2] * 2 + 0.1
                  ]);
                  
                translate([-2.5, 1.2, 0])  
                  cube([
                    5, 
                    PROMICRO_BOX[1] - 13.29, 
                    PROMICRO_BOX[2] * 2 + 0.1
                  ]);                                    
              }
              
            translate([1, 12.01, 0])
              cube([2, 15, 2]);
             
            translate([-5, 12.01, 0]) 
              cube([4, 15, 3.5]);
                  
            translate([
              PROMICRO_T[0] - 1.2, 
              PROMICRO_T[1] - 2.2, 
              PROMICRO_BOX[2] * 2
            ]) 
              cube([
                PROMICRO_BOX[0] + 2.4 + 1.8, 
                2.4 + 1, 
                1
              ]);
          }
          
        translate([
          PROMICRO_T[0] + 
            (PROMICRO_BOX[0] - USB_BOX[0]) / 2 - 8,    
          PROMICRO_BOX[1] + PROMICRO_T[1] + 1.9, 
          -2
         ]) { 
          cube([
            USB_BOX[0] + 8,
            USB_BOX[1],
            USB_BOX[2] * 2
          ]);
           
         translate([8, -4, 2])
           cube([
            USB_BOX[0],
            USB_BOX[1] + 5,
            USB_BOX[2] * 2
          ]);
        }   
          
        *translate([-0.4, 32, 0.2 * 18]) 
          rotate([90, 0, 0]) {
            cylinder(20, d = 8.6);    
            translate([0, 0, 1]) 
              cylinder(5, d = 11.4);    
            translate([0, 4, 4]) 
              cube([8.6, 8, 10], center = true);
            
            translate([0, 5, 1.2]) 
              cube([11.4, 8, 10], center = true);
            
            translate([0, 4, 1]) 
              cube([11.4, 8, 10], center = true);
          }

        rotate([180, 0, 0]) 
          lilyScrewSlicer([22.2, -27, 2], 6);

        rotate([180, 0, 0])
          lilyScrewSlicer([0, 17, 2], 6);
        }
      }
    
