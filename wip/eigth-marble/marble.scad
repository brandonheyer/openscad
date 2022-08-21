//MD = 3.175;
MD = 4.7625;
LAYER_HEIGHT = 0.2;

// REFERENCE CIRCLE
*translate([0, 5 * MD / 6])  circle(d = MD, $fn = 32);

// Figure S Track
*group() {
  difference() {
    union() {
      rotate([0,0,45]) rotate_extrude(angle = 270, $fn = 128)
        translate([10, 0, 0])
          flatTrack();

      translate([cos(45) * 20, sin(45) * 20])
        rotate([0,0,-135]) rotate_extrude(angle = 270, $fn = 128)
          translate([10, 0, 0])
            flatTrack();
    }
  }
}

H_EXTRA = 0;
hExtra = H_EXTRA;
holeDLayers = ceil(MD * 1.25 / LAYER_HEIGHT);
holeD = holeDLayers * LAYER_HEIGHT;
ty = holeD - 0.2;
baseYs = [6, holeDLayers + hExtra];
base = [MD * 2.1, LAYER_HEIGHT * (baseYs[0] + baseYs[1])];

group() {
  trackConnectorTunnel();

  translate([MD, ty, 4.9]) {
    difference() {
      union() {
        translate(
          [
            -base[0], 
            -base[1] / 2 - 2.2, 
            0.1
          ]
        )
        
        hull() {
          linear_extrude(0.1)
            translate([0, -base[1] / 2 + 1.2])
            square([base[0] * 2, base[1]]);
            
            translate([0, base[1] / 2, 8]) 
              linear_extrude(0.2)
                square([base[0] * 2, base[1] / 3]);          
        }
      }
      
      rotate([90, 0, 0])
        rotate_extrude(angle = 180, convexity = 4, $fn = 64) 
          translate([MD, 0, 0]) 
            circle(d = holeD, $fn = 32);
    }  
  }

  translate([MD * 2, 0])
    trackConnectorTunnel(angle = -8);
}

*linear_extrude(30) flatTrack();

*translate([0, MD + 0.15]) circle(d = MD, $fn = 32);


module tunnelPair(h, baseTr, base, holeTr, holeD, angle = 5) {
  difference() {
    difference() {
    linear_extrude(h)
      translate(baseTr) 
        square(base);
      
    translate(holeTr)
      translate([0, 0, -0.1])
      hull() {
        cylinder(h = 0.01, d = holeD * 1.25, $fn = 32);
        
        translate([0, 0, h + 0.1]) 
          cylinder(h = 0.01, d = holeD, $fn = 32);
     
     }
 }
      
  ty = (angle < 0 ? 1 : -1) * sin(angle) * FTY2 * LAYER_HEIGHT;
 
  translate([0, angle < 0 ? ty * 2: 0, angle < 0 ? 0 : ty]) 
    rotate([angle, 0, 0]) 
      linear_extrude(h) 
        flatTrack(lowerMid = false);
  }
}

module trackConnectorTunnel(d = MD, h = 5, lh = LAYER_HEIGHT, angle = 8, hExtra = H_EXTRA) {
  holeDLayers = ceil(d * 1.25 / lh);
  holeD = holeDLayers * lh;
  holeTr = [0, holeD - 0.2];

  baseYs = [12, holeDLayers + hExtra - 6];
  base = [d * 2.2, lh * (baseYs[0] + baseYs[1])];
  baseTr = [-base[0] / 2, -1 * lh * baseYs[0]];
  
  translate([0, 0, h]) {
    translate([0, 0, -(h - 1)]) 
      tunnelPair(h - 1, baseTr, base, holeTr, holeD, angle);
    
    *translate([0, 0, 0])
      linear_extrude(1)
        difference() {
          translate(baseTr) 
            square(base);

          translate(holeTr)
            circle(d = holeD, $fn = 32);
        }
  }
}

FTY1 = 7;
FTY2 = 17;

module flatTrack(d = MD, lh = LAYER_HEIGHT, lowerMid = true) {
  ys = [0, FTY1, FTY2];
  halfD = d / 2;
  r = d / 2;
  sinHalfD = halfD * sin(45);
  h = lh * 8;
  
  polygon([
    [r, 0],
    [r - 0.1, ys[0] * lh],
    [r + 0.3, ys[1] * lh],
    [r - 0.7, ys[2] * lh],
    lowerMid ? [0, ys[1] * lh] : [0, ys[2] * lh],
    [-r + 0.7, ys[2] * lh],
    [-r - 0.3, ys[1] * lh],
    [-r + 0.1, ys[0] * lh],
    [-r, 0],
  ]);
}

module uTrackSlicer(d = MD) {
  circle(d = d, $fn = 64);
}

module uTrack(d = MD) {
  innerD = d;
  outerD = d + (0.4 * 5);
  
  baseW = outerD * cos(45);
  baseTX = -baseW / 2;
  baseTY = -d / 1.125 * cos(30);
  
  intersection() {
    difference() {
      union() {
        circle(d = outerD, $fn = 8);
        translate([baseTX, baseTY]) 
          square([baseW, d]);
      }
      
      uTrackSlicer(d);
    }
    
    translate([-innerD, baseTY])
      square([innerD * 2, outerD / 3]);
  }
}