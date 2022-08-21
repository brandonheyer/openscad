WALL_SIZE = .5;
RADIUS = 3;
DEFAULT_SIZE = [10, 10];
RRR = 0;
LAYER_HEIGHT = 0.2;

module reinforcementsLeft(size, radius, wallSize, parts = [1, 1]) {
  diameter = radius * 2;
  halfRadius = radius / 2;

  r = radius * 4;
  d1 = -halfRadius;
  d2 = -halfRadius;
  d3 = size[1] - r + halfRadius;
  
  if (parts[0])
    translate([d1, d2, 0])
      circle(d = radius * 4, $fn = 32);
      
  if (parts[1])
    translate([d1, d3, 0])
      circle(d = radius * 4, $fn = 32);
}

module reinforcementsRight(size, radius, wallSize, parts = [1, 1]) { 
  diameter = radius * 2;
  r = radius * 4;
  halfRadius = radius / 2;
  d2 = size[0] - r + halfRadius;
  d3 = size[1] - r + halfRadius; 
  d4 = -halfRadius;

  if (parts[0])
    translate([d2, d4, 0])
      circle(d = radius * 4, $fn = 32);
  
  if (parts[1])
    translate([d2, d3, 0])
      circle(d = radius * 4, $fn = 32);        
}

module reinforcements(size, radius, wallSize, parts = [1, 1, 1, 1]) {
  reinforcementsLeft(size, radius, wallSize, [parts[0], parts[1]]);
  reinforcementsRight(size, radius, wallSize, [parts[2], parts[3]]);
}

module duct2dEdge(
  size = DEFAULT_SIZE, 
  wallSize = WALL_SIZE, 
  radius = RADIUS, 
  outer = false, 
  parts = [1,1,1,1]
) {
  sizeX = size[0] + (outer ? wallSize * 2 : 0);
  sizeY = size[1] + (outer ? wallSize * 2 : 0);
  r = radius + (outer ? wallSize : 0);
  
  translate([sizeX / -2 + r * 2, sizeY / -2 + r * 2, 0]) {
    minkowski() {
      square([sizeX - (r * 2), sizeY - (r * 2)]);
      
      translate([-r, -r, 0])
        circle(r, $fn = 64);
    }
   
    if (outer) reinforcements([sizeX, sizeY], r, wallSize, parts = parts);
  }
}

module duct2d(
  size = DEFAULT_SIZE,
  wallSize = WALL_SIZE, 
  radius = RADIUS
) {
  difference() {
    duct2dEdge(
      size,
      wallSize,
      radius,
      outer = true
    );
    
    duct2dEdge(
      size, 
      wallSize,
      radius
    );
  }
}

module coupling2d(size = [10, 10], wallSize = WALL_SIZE, radius = RADIUS, inset = 0) {
  offset(r = -0.1) difference() {
      *duct2dEdge(
        [
          size[0] + wallSize * 2 + radius * 2.5, 
          size[1] + wallSize * 2 + radius * 2.5
        ], 
        wallSize,
        radius
      );
      
      duct2dEdge(
        [
          size[0] + wallSize * 2 - inset, 
          size[1] + wallSize * 2 - inset
        ], 
        wallSize,
        radius + wallSize,
        outer = true
      );
    }
}

module coupling(size = [10, 10], wallSize = WALL_SIZE, radius = RADIUS, h = 4) {
    split = 0.6;
    partHeight = (h - (LAYER_HEIGHT * 4)) / 2;

    difference() {
      linear_extrude(h) 
        offset(2) 
          coupling2d(size, wallSize, radius);
   
      translate([0, 0, -0.1])
        linear_extrude(partHeight + 0.2)
          coupling2d(size, wallSize, radius + 0.2);
       
      translate([0, 0, partHeight - 0.1]) 
        linear_extrude(LAYER_HEIGHT * 1 + 0.2)
          offset(-0.2)
            coupling2d(size, wallSize, radius + 0.2);
      
      translate([0, 0, partHeight - 0.1 + LAYER_HEIGHT]) 
        linear_extrude(LAYER_HEIGHT * 2 + 0.2)
          offset(-0.4)
            coupling2d(size, wallSize, radius + 0.2);
      
      translate([0, 0, partHeight + LAYER_HEIGHT + LAYER_HEIGHT + LAYER_HEIGHT - 0.1]) 
        linear_extrude(LAYER_HEIGHT * 1 + 0.2)
          offset(-0.2)
            coupling2d(size, wallSize, radius + 0.2);

      
      translate([0, 0, partHeight + (LAYER_HEIGHT * 4) - 0.1])
        linear_extrude(partHeight + (LAYER_HEIGHT * 4) + 0.1)
          coupling2d(size, wallSize, radius + 0.2);
    }
}

module ductTaper(
  startSize = DEFAULT_SIZE, 
  endSize = [DEFAULT_SIZE[0] - 2, DEFAULT_SIZE[1] - 2], 
  wallSize = WALL_SIZE, 
  radius = RADIUS, 
  h = 10,
  yPlus = 12,
  parts = [1,1,1,1]
) {
  upperY = startSize[1] / 2 - endSize[1] / 2;

  difference() {
    union() {
      intersection() {
        union() {
          linear_extrude(h)
            duct2dEdge(
              [
                startSize[0], 
                startSize[1]
              ],
              wallSize,
              radius + wallSize,
              outer = true,
              parts = parts
            );
        }
          
        hull() {
          translate([0, 0, -0.1]) 
            linear_extrude(0.2) 
              offset(2)
                duct2dEdge(startSize, wallSize, radius, parts);
          
          translate([0, upperY - yPlus / 2, h - 0.1]) 
            linear_extrude(0.2) 
              offset(2) 
                duct2dEdge(
                  [endSize[0], endSize[1] + yPlus], 
                  wallSize, 
                  radius - wallSize * 4,
                parts
                );
        }  
      }
        
      children();
    }
    
    hull() {
      translate([0, 0, -0.1]) 
        linear_extrude(0.2) duct2dEdge(startSize, wallSize, radius);
      
      translate([0, startSize[1] / 2 - endSize[1] / 2 - radius * .5, h - 0.1]) 
        linear_extrude(0.2) duct2dEdge(endSize, wallSize, radius);
    }
   
  } 

  translate([0,endSize[1] - radius * 2.5 + WALL_SIZE * 2, h])
    linear_extrude(5)
      duct2d(
        [
          endSize[0], 
          endSize[1]
        ],
        wallSize,
        radius,
        outer = true
      );
}

   
group() {

  translate([0, 32, 0]) {
    coupling([50, 20]);
    *coupling([40, 10]);
  }
  
  *translate([0, 0, 0]) {
    hull() {
      linear_extrude(1) 
        duct2d([40, 10]);
      
      translate([0, 5, 20]) linear_extrude(1) 
        duct2d([50, 20]);
    }
  }

  translate([0, -32, 0]) {
    rotate([0,0,0]) linear_extrude(8) duct2d([50, 40]);
  }
  
  *translate([0, -25, 0]) {
    linear_extrude(6) duct2d([50, 20]);
  }
  
  group() {
    ductTaper([50, 20], [40, 10], h = 15);
  }
  
  *translate([0, -30, -10]) 
    linear_extrude(15) duct2d([50 - WALL_SIZE * 2, 20 - WALL_SIZE * 2]);

  *translate([0, 25, -10]) 
    linear_extrude(15) duct2d([40 + WALL_SIZE * 2, 10 + WALL_SIZE * 2]);

  *  duct2d([50, 10]);
  *  translate([0,0,20]) duct2d([50, 10]);

  *square([50, 10], center = true);
}

