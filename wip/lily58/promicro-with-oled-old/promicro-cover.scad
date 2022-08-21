w = 33;
d = 18.2;
h = 1.5 + .1;

USB_PADDING = 4.4;
OVERLAP = 2.5;
XMAX = 1.1;
JACKD = 8 + 0.2;
tx = 1.25;
ty = 0.4;
HEADER_D = 3;
HEADER_H = 0.2 * 8;
H_MULT = 16;

OLED_OFFSET = 0.8;
OLED_BW = 25.3 + OLED_OFFSET;
OLED_BD = 26.1 + OLED_OFFSET;
OLED_H = 6;

BASE_W = w + (2 * tx) + 0.4;
BASE_D = d + 0.4;
BASE_H = (0.2 * 3) + HEADER_H;

SIDE_H = BASE_H + (0.2 * H_MULT + h);
SIDE_T = 1.6;
SIDE_LONG = w + .6 + .5 + 0.4;
SLTX = SIDE_T - 0.2;

PCB_W = d + 0.4;

OLED_SW = 25.3;
OLED_SD = 16.8;

OLED_B = [OLED_BD + 9.2, OLED_BW, OLED_H];
OLED_S = [OLED_SD + 1.2, OLED_SW, 8];
OLED_B2 = [
  OLED_B[0] + 4.15, 
  OLED_B[1] + 0.9, 
  OLED_B[2] - 4
];

MIC_D = 8.6;
MIC_D_RING = 11;


OLED_TY = (OLED_BW - BASE_W) / 2 + 1.35 - OLED_OFFSET;  
w1 = 3.45;

WALL_POLY = [
  [-2.8, -4.8],
  
  [w + w1 + 1, -4.8],
  [w + w1 + 1, 3],  
  [w + w1 - 3.1, 3],
  [w + w1 - 3.1, -2.0],
  [w + w1 - 11.1, -2],
  
  [w + w1 - 11.1, -5.15 + 1.2],
  [-2.4 + 1.2, -5.15 + 1.2],
  [-2.4 + 1.2, d + 4.35 - 1.2],
  [w + w1 - 11.1, d + 4.35 - 1.2],
  
  [w + w1 - 11.1, d - 0.2],
  [w + w1 - 3.1, d - 0.2],
  [w + w1 - 3.1, d + 4.35 - 8.15],
  [w + w1 + 1, d + 4.35 - 8.15],
  [w + w1 + 1, d + 4.0],
  
  [-2.8, d + 4.0]
];

BR = 3;

module clip(d, zr = 0) {
  rotate([90, 0, zr])
    translate([-1.8, 0, 0])
      linear_extrude(d)
        polygon([          
          [2.2, h - 4],
          [2.2, h * 1.75],
          [0, h * 1.75],
          [0, h * 1.5],
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
 
intersection() {
  if (!$preview) {
    translate([
      -2.35 - SIDE_T - 0.05, 
      OLED_TY - 0.45, 
      -OLED_H
    ])
      translate([0, 0, -0.2 * 12 - .6 - 1]) {
        H = OLED_B2[2] + 18;
        translate([BR, OLED_B2[1] - BR - .12, 0]) 
          scale([.6, 1.04, 1]) 
            cylinder(H, d = BR * 2, $fn = 32);
        
        translate([OLED_B2[0] - BR, OLED_B2[1] - BR, 0])
          cylinder(H, d = BR * 2, $fn = 32);
        
        translate([OLED_B2[0] - BR, BR, 0]) 
          cylinder(H, d = BR * 2, $fn = 32);
        
        translate([BR, BR + .12, 0]) scale([.6, 1.04, 1]) 
          cylinder(H, d = BR * 2, $fn = 32);
        
        translate([BR, 0, 0]) 
          cube([OLED_B2[0] - BR * 2, OLED_B2[1], OLED_B2[2] + 18]);
        
        translate([0, BR, 0]) 
          cube([OLED_B2[0], OLED_B2[1] - BR * 2, OLED_B2[2] + 18  ]);
      }
  }

  union() {
    // OLED COVER
    translate([
      0 - SIDE_T - 0.05, 
      OLED_TY, 
      -OLED_H
    ])
      difference() {    
        translate([-1.15, -.45, -.2 * 12 - 1.6])
          cube(OLED_B2);
        
        translate([-2.35, 0, 0]) {
          translate([OLED_BD - OLED_SD - 3 - 1.2, 0.4, -7])
            cube(OLED_S);
                    
          translate([OLED_BD - OLED_SD - 7.39, 0.4, -3.2])          
            cube([3.2, OLED_BW - 0.8, 3]);
          
          translate([OLED_BD - 3.1, 2.3, -3.2])
            cube([4, OLED_BW - 6, 2]);                
        }
      }
        
      // PCB CLIPS
      group() {
        translate([-0.9, -0.6, BASE_H])
          union() {
            translate([0, -4, 2])
              clip(PCB_W + 8.2, 180);
          
            translate([0, -4, -2])
              clip(PCB_W + 8.2, 180);
          }
       
        translate([w + 0.15, -2.6, BASE_H]) 
          translate([-1.8, 3.6, 0])
            cube([2, 18, 0.2 * 2]);
      }

      // PCB BASE
      difference() {
        union() {   
         difference() {
          translate([w + 1.65, d - 0.8, -8])
            linear_extrude(15, convexity = 3, slices = 15 / 0.4)
              rotate([0, 0, 180])
                polygon(WALL_POLY); 

            ch = d + 6.9;
           
            translate([w - 5, -3.95, 8]) {
              translate([0, -0.0, 0])
              rotate([0, 30, 0])
                rotate([0, 90, 90])
                  cylinder(h = ch + 0.2 + 1.6, d = 13.81, $fn = 3);
              
              translate([-w + 3.75, d + 6, -6])
                cube([w - 7.2, 4, 5.1]);
            }
          }
        
          // BASE
          translate([4 + w - MIC_D, -ty - 0.2, 0])      
            cube([
              6, 
              BASE_D, 
              BASE_H
            ]);
          
          // SIDES
          translate([-1.25 - 0.2, -2.2, 0]) {  
            OLED_EXTRA = 2.95;
            SIDE_T_2 = SIDE_T + OLED_EXTRA;      

            translate([
              -1 + w + 3.5 - 0.7, 
              -OLED_EXTRA + 7.95, 
              -8
            ]) 
              cube([SIDE_T + 1.5, 11.8, 11]);         
          }
        }  
        
        // MIC SLICERS
        group () {
          translate([
            w - SIDE_T * 2 - 0.45,
            0,
            -0.8 - 0.8
          ]) {
            *translate([0, 3, -1.5])
              rotate([0, 90, -90]) 
                translate([0, 1, 2])
                  cylinder(d = MIC_D_RING, h = 3, $fn = 64);
          
              rotate([0, 90, -90]) 
                translate([0, 1, 0])
                  cylinder(d = MIC_D, h = 8, $fn = 64);
          }
          
          
          // MIC OVERHANG REMOVAL
          translate([
            w - SIDE_T * 2 - SIDE_T * 2 + 0.8 - 1, 
            -0.2,
            0
          ])
            cube([5, d, HEADER_H + 4]);
        }      
        
        translate([20, -6, -1]) 
          rotate([0, 90, 90])
            cylinder(d = 4, h = 3, $fn = 32);
      }
  }
}