//MD = 3.175;
MD = 4.7625;
LAYER_HEIGHT = 0.2;

// REFERENCE CIRCLE
*translate([0, 5 * MD / 6])  circle(d = MD, $fn = 32);

// S
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




module tunnelPair(h, baseTr, base, holeTr, holeD, angle = 5) {
  difference() {
    linear_extrude(h / 3)
      difference() {
        translate(baseTr) 
          square(base);

        translate(holeTr)
          circle(d = holeD, $fn = 32);
      }
      
    rotate([angle, 0, 0]) 
      translate([0, 0, -h / 2]) 
        linear_extrude(h) 
          flatTrack(lowerMid = false);
  }
}

module trackConnectorTunnel(d = MD, h = 5, lh = LAYER_HEIGHT, angle = 5, hExtra = H_EXTRA) {
  holeDLayers = ceil(d * 1.25 / lh);
  holeD = holeDLayers * lh;
  holeTr = [0, holeD - 0.2];

  baseYs = [6, holeDLayers + hExtra];
  base = [d * 2, lh * (baseYs[0] + baseYs[1])];
  baseTr = [-base[0] / 2, -1 * lh * baseYs[0]];
  
  tunnelPair(h, baseTr, base, holeTr, holeD, angle);
    
  translate([0, 0, h / 3])
    linear_extrude(2 * h / 3)
      difference() {
        translate(baseTr) 
          square(base);

        translate(holeTr)
          circle(d = holeD, $fn = 32);
      }
}

H_EXTRA = 20;
hExtra = H_EXTRA;
holeDLayers = ceil(MD * 1.25 / LAYER_HEIGHT);
holeD = holeDLayers * LAYER_HEIGHT;
ty = holeD - 0.2;
baseYs = [6, holeDLayers + hExtra];
base = [MD * 2, LAYER_HEIGHT * (baseYs[0] + baseYs[1])];

*group() {
  trackConnectorTunnel();

  translate([MD, ty, 4.9]) {
    difference() {
      union() {
        translate([-base[0], -base[1] / 2 - 1.4, 0.1])
          hull() {
            linear_extrude(1)
              square([base[0] * 2, base[1] / 1.5]);
            
            translate([0, 3 * base[1] / 6, 8]) 
              linear_extrude(1)
                square([base[0] * 2, base[1] / 6]);          
          }
      }
      
      rotate([90, 0, 0])
        rotate_extrude(angle = 180, convexity = 4, $fn = 64) 
          translate([MD, 0, 0]) 
            circle(d = holeD, $fn = 32);
    }  
  }

  translate([MD * 2, 0])
    trackConnectorTunnel(angle = -5);
}

linear_extrude(30) flatTrack();

*translate([0, MD + 0.15]) circle(d = MD, $fn = 32);


module flatTrack(d = MD, lh = LAYER_HEIGHT, lowerMid = true) {
  ys = [0, 7, 17];
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