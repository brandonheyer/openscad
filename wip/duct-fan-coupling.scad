use <./duct.scad>;
CORNER_RADIUS = 20;
WALL_SIZE = .5;
RADIUS = 3.5;
DEFAULT_SIZE = [10, 10];
SOLID = true;
WIDTH = 40;
HEIGHT = 20;
T_WIDTH = 5;
LW = 0.4;

FAN_SIZE = [92, 92, 18];
MAIN_SIZE = [105, 126, 34];
SINK_SIZE = [59, 67, 20];
SINK_Y = (MAIN_SIZE[1] - SINK_SIZE[1]) / 2;
SINK_Z = 5;
BASE_SIZE = [
  MAIN_SIZE[1],
  FAN_SIZE[2] + MAIN_SIZE[2] + SINK_SIZE[2]
];

echo(BASE_SIZE);

*group() {
  color("blue") 
    translate([-MAIN_SIZE[2], (MAIN_SIZE[1] - FAN_SIZE[1]) / 2, 5]) 
      rotate([0, 270, 0])
        cube(FAN_SIZE);
  
  color("silver")
    translate([SINK_SIZE[2], SINK_Y, SINK_Z]) 
      rotate([0, 270, 0])
        cube(SINK_SIZE);
  
  color("gray") 
      rotate([0, 270, 0]) 
        cube(MAIN_SIZE);
}

PADDING = 4;
HALF_PAD = PADDING / 2;
Y_GAP = 16;
FAN_X_GAP = 16;
CH = SINK_SIZE[0] + SINK_Z + PADDING;
CR = 15;

difference() {
  translate([
    -BASE_SIZE[1] + SINK_SIZE[2] - PADDING - FAN_X_GAP, 
    (BASE_SIZE[0] - MAIN_SIZE[1]) / -2 - PADDING - Y_GAP, 
    1
  ])
    cube([
      BASE_SIZE[1] + PADDING * 2 + FAN_X_GAP, 
      BASE_SIZE[0] + PADDING * 2 + Y_GAP, 
      CH - 2
    ]);

  union() {
    translate([
      SINK_SIZE[2] - CR + HALF_PAD, 
      CR - HALF_PAD -Y_GAP, 
      0
    ])
        cylinder(CH, d = CR * 2);
      
    translate([
      -MAIN_SIZE[0] + CR * 2 + PADDING + FAN_X_GAP, 
      CR - HALF_PAD -Y_GAP, 
      0
    ])
        cylinder(CH, d = CR * 2);
        
    translate([
      -MAIN_SIZE[0] + CR * 2 + PADDING + FAN_X_GAP, 
      MAIN_SIZE[1] - CR * 2, 
      0
     ])
      cylinder(CH, d = CR * 2);

    translate([
      -BASE_SIZE[1] + HALF_PAD, 
      -Y_GAP - HALF_PAD + CR, 
      0
    ])
      cube([
        BASE_SIZE[1] + PADDING + FAN_X_GAP, 
        BASE_SIZE[0] - Y_GAP - CR + PADDING, 
        CH
      ]);

        
    translate([
      -BASE_SIZE[1] + HALF_PAD + CR, 
      -Y_GAP - HALF_PAD, 
      0
    ])
      cube([
        BASE_SIZE[1] + PADDING + FAN_X_GAP - CR * 2, 
        BASE_SIZE[0] + Y_GAP - CR + PADDING / 2, 
        CH
      ]);
     
    cube([
      SINK_SIZE[2] + PADDING / 2, 
      BASE_SIZE[0] + PADDING + 0.1, 
      CH
    ]);
    
    translate([-MAIN_SIZE[2] - 0.5, 0.5, 0])
    cube([
      SINK_SIZE[2] + MAIN_SIZE[2] + PADDING / 2, 
      BASE_SIZE[0], 
      CH
    ]);
    
    translate([-1, SINK_Y - 1, -20]) 
      cube([
        SINK_SIZE[2] + 2, 
        SINK_SIZE[1] + 2, 
        SINK_SIZE[0]
      ]);
  }
}

*linear_extrude(MAIN_SIZE[1])
  ductSpiral(BASE_SIZE, CORNER_RADIUS, texture = true);
  
*ductTaper(
  BASE_SIZE, 
  10,
  CORNER_RADIUS
);

*rotate([0, 180, 0])
  translate([-BASE_SIZE[0], 0, -MAIN_SIZE[1]])
    ductTaper(
      BASE_SIZE, 
      10,
      CORNER_RADIUS
    );

module ductTaper(
  size = [WIDTH, HEIGHT], 
  h = 5, 
  th = 25,
  r = CORNER_RADIUS, 
  texture = false, 
  offset = LW * 2) 
{
  difference() {
    hull() {
      linear_extrude(h) 
        offset(offset) 
          ductSpiral(size, r, texture);
      
      translate([0, 0, h])
        linear_extrude(th) 
          offset(-3) 
            ductSpiral(size, r, texture);
    }
  }
}



curveScale = 0.13;
curveHeight = 40;
curveY = -3;

module dShape(
  d = 100,
  tY = curveY, 
  s1t = [-60, -115], 
  s2t = [-50, 47], 
  s1 = false, 
  s2 = false,
  $fn = 8
) {
  translate([0, tY, 0]) {
    difference() {
      circle(d = d, $fn = $fn);
      translate(s1t) square(abs(s1t[0] * 2));
      translate(s2t) square(s2 == false ? 100 : s2);
    }      
  }
}


module dTaper(d = 108, h = 40, s1t = false, s2t = false, topT = 0, fn = 16) {
  hull() {
    linear_extrude(1) {
      if (s1t == false && s2t == false) {
        dShape(d, $fn = fn);  
      } else {
        dShape(d, s1t = s1t, s2t = s2t, $fn = fn);  
      }
    }
    
    translate([(d / -2) + 20, topT, h - 1]) 
      linear_extrude(1) 
        square([d - 40, 3]);
  }
}

module fc() {
    // BOTTOM COUPLING
  linear_extrude(8) {
    diameter = RADIUS * 2;
    twoWall = WALL_SIZE * 2;
    
    difference() {
      // BOTTOM OUTER WALL
      union() {
        duct2dEdge([110, 50], WALL_SIZE, RADIUS, outer = true);      
        dShape(104, $fn = 16);
      }
      
      // BOTTOM INNER WALL
      group() {
        translate([0, RADIUS * -2 - WALL_SIZE + 7.5, 0]) {
          duct2dEdge([110, 50], WALL_SIZE, RADIUS);
        }

        dShape(99, curveY, [-50, -100], [-50, 44.5], s2 = [100, 22], $fn = 128);
      }
    }
  }
}


module fanCoupling() {
  fc();

  // TAPER
  translate([0, 0, 5]) {
    twoWall = WALL_SIZE * 2;
    
    // OUTER SHELL
    union() {
      rotate([0, 0, 180]) 
        translate([twoWall - 1, twoWall - 1, 0])
          ductTaper(
            [110, 50],  
            [80, 20],
            wallSize = WALL_SIZE,
            radius = 3,
            h = curveHeight,
            parts = [0,0,0,0]
          ) {
      
            // D TAPER
            rotate([0,0,180]) {
              linear_extrude(4) dShape(104, $fn = 16);
              translate([0,0, 4]) dTaper(104, 36, $fn = 8);
              
              linear_extrude(15) 
                translate([-55 + 7 + WALL_SIZE, -25 + 7 + WALL_SIZE, -5]) 
                  reinforcements(
                    [110 + WALL_SIZE * 2, 50 + WALL_SIZE* 2], 
                    3 + WALL_SIZE * 2, 
                    WALL_SIZE
                  );
            }
            
          }
    }
  }

  translate([20, 33, 0]) cylinder(5, d = 13);
  translate([00, 33, 0]) cylinder(5, d = 13);
  translate([-20, 33, 0]) cylinder(5, d = 13);
}

module defrostVent2d(wallSize = WALL_SIZE, solid = SOLID) {
  offset = 10;
  v1 = 30;
  v1y = 92 + offset;
  v2 = 60;
  v3y = 92 + offset;
  
  translate([0, 80, 0]) {
    translate([0, 0, 0]) {
      difference() {
        translate([-wallSize, -wallSize, 0]) 
          square([v1 + wallSize * 2, v1y + wallSize * 2]);

        if (!solid) translate([0, -wallSize * 2]) square([v1, v1y + wallSize * 2]);
      }

      translate([v1, 0, 0])
        difference() {
          difference() {
            circle(r = v1 + wallSize, $fn = 64);
            if (!solid) circle(r = v1, $fn = 64);
          }
          
          translate([-v1 - 10, 0]) square([v1 * 2 + 20, v1 * 2]);
          translate([wallSize, -v1 - 10]) square([v1 * 2, v1 * 2 + 20]);
        }
      }
    
    translate([v1 + wallSize, 0, 0]) {
      if (solid) {
        translate([0, -v1 - wallSize, 0]) square([v2, v1 + wallSize]);
      } else {
        translate([0,-wallSize,0]) square([v2, wallSize]);
        translate([0,-v1 - wallSize,0]) square([v2, wallSize]);
      }
    }
    
    translate([v1 + v2 + wallSize * 2, 0, 0]) {
      difference() {
        difference() {
          circle(r = v1 + wallSize, $fn = 64);
          if (!solid) circle(r = v1, $fn = 64);
        }
        
        translate([-35, 0]) square([70, 40]);
        translate([-40 - wallSize, -35]) square([40, 70]);
      }
      
      difference() {
        translate([-wallSize, -wallSize, 0]) 
          square([v1 + wallSize * 2, v3y + wallSize * 2]);

        if (!solid) translate([0, -wallSize * 2]) square([v1, v3y + wallSize * 2 + 5]);
      }
    }
  }
}







  

*fanCoupling();
*fc();
*defrostVent2d();

*linear_extrude(10) union() {
      duct2dEdge([110, 50], WALL_SIZE, RADIUS, outer = true, parts = [0,0,0,0]);      
      dShape(104, $fn = 16);
    }
    
*group() {
  hull() {
    linear_extrude(10) 
      union() {
        duct2dEdge([110, 50], WALL_SIZE, RADIUS, outer = true, parts = [0,0,0,0]);      
        dShape(104, $fn = 16);
      }
      
      translate([-46, -10, 40])
      rotate([-30, 0, 0])
      linear_extrude(5) 
        ductSpiral([92, 36]);
  *      duct2dEdge([110, 50], WALL_SIZE, RADIUS, outer = true, parts = [0,0,0,0]);      
  }
   
       translate([-46, -10, 40]) rotate([-30, 0, 0]) translate([0,0,5]) {
          difference() {
            linear_extrude(40) ductSpiral([92, 36]);  
            linear_extrude(45) offset(-0.4) ductSpiral([92, 36]);  
          }
        }  
}



module ductSpiral(
  size = [WIDTH, HEIGHT], 
  r = CORNER_RADIUS, 
  texture = false
) {
  w = size[0];
  h = size[1];
  
  width = w - r;
  height = h - r;
  
  difference() {
    union() {
      for (x = [r, width])
        for (y = [r, height])
          translate([x, y])
            circle(r, $fn = 64);
        
      translate([0, r])
        square([w, h - r * 2]);
      
      translate([r, 0])
        square([w - r * 2, h]);    
    }
    
    if (texture) {
      wMax = w - r;
      hMax = h - r;
 
      xSize = 4;
      xSegments = floor((width - r) / xSize);
      xCount = xSegments % 2 == 0 ? 
        xSegments - 1 : 
        xSegments;
      
      xRatio = (width - r) / (xCount * 180);
      
      ySize = 4;
      ySegments = floor((height - r) / ySize);
      yCount = ySegments % 2 == 0 ? 
        ySegments - 1 : 
        ySegments;
      yRatio = (height - r) / (yCount * 180);
      
      echo(xCount, yCount);
      
      for (y = [0, 1])
        translate([r, .5 - y + h * y])
          mirror([0, y - 1, 0])
            polygon([
              [0, 2],
              for (t = [90 : 30 : xCount * 180 - 90])
                [t * xRatio, sin(t) / 2],
              [width - r, 2]
            ]);


      for(x = [0, 1])
        translate([.5 - x + w * x, r])
          mirror([x - 1, 0])
            polygon([
              [2, 0],
              for (t = [90 : 30 : yCount * 180 - 90])
                [sin(t) / 2, t * yRatio],
              [2, height - r]
            ]);
    }
  }
}