include <./seed.scad>;

DIAMETER = 20.8;
EDGE_RADIUS = 5;
MAX_DEPTH = 10;
SEGMENT_HEIGHT = 4;

module edge(
  h = SEGMENT_HEIGHT, 
  tz = 0, 
  radius = EDGE_RADIUS, 
  depth = MAX_DEPTH, 
  segments = 10
) {
  rndMax = radius / 2;
  
  kRnd = depth <= 2 ? rndMax : depth >= segments - 2 ? radius / 1.75 : rndMax;
  kShift = depth <= 2 ? rndMax * .75 : depth >= segments - 2 ? 0 : rndMax / 2;
  
  k = (rands(1, kRnd + 1, 1)[0] - kShift) / 2;
  r = rands(0, 20, 1)[0] - 10;
  
  translate([0, 0, tz]) rotate([0, 0, 0]) {
    cylinder(h, radius, radius - k, $fn = 12);
    
    if (depth > 1) {
      edge(h, h, radius - k, depth - 1, segments = segments);
    }
  }
}

module holder(
  height, 
  segments, 
  radius = EDGE_RADIUS, 
  tx = DIAMETER / 2, 
  hole = [0, 0], 
  parts = 10, 
  diameter = DIAMETER, 
  seed = false
) {
  seedData = seed ? getSeed(seed) : getSeed();
  
  difference() {
    r = rands(0, 90, 1)[0];
    p = rands(0, 1, 1)[0];
    
    union() {
      for (i = [0 : 360 / parts : 360]) {
        rotate([0, 0, i]) 
          translate([tx, 0, 0]) {
            rotate([0, 0, r]) 
              union() {
                edge(
                  h = height / segments, 
                  depth = segments, 
                  radius = radius - p, 
                  segments = segments
                );
              }
          }
      }
      
      cylinder(hole ? 10 : height, d = diameter, $fn = 5);
    }
    
    if (hole) {
      holeX = hole == true ? 0 : hole[0];
      holeY = hole == true ? 0 : hole[1];
      
      translate([holeX, holeY, diameter / 2.01 + 1])
        cylinder(height + 1, d = diameter, $fn = 32);
        
      translate([holeX, holeY, 0])
        translate([0, 0, diameter / 2 + 1])
          sphere(d = diameter);
    }
  }

  *translate([diameter + radius + radius, 0, 0]) rotate([0, 0, 90])
    rotate([0, 0, 20])
      linear_extrude(2)
        text(seedData[0], halign = "center", size = 6);
}

group() {
  holder(40, 4, 12, DIAMETER / 2.2, hole = true, parts = 12);

  *difference() {
    union() {
      translate([-6, 20, 0])
        holder(40, 2, 8, DIAMETER / 7, hole = false, parts = 6, diameter = 2);

      translate([10, 20, 0])
        holder(20, 1, 8, DIAMETER / 2, hole = false, parts = 18, diameter = 15);
    }

    translate([2.5, 3, 0])
      cylinder(71, d = DIAMETER, $fn = 32);
  }
}

*group() {
  holder(100, 4, 10, DIAMETER / 2.9, hole = true, parts = 16, holeX = 0, holeY = 2);
  
  *difference() {
    translate([-14, 20, 0]) 
      holder(20, 1, 14, DIAMETER / 1.8, hole = false, parts = 9, holeX = 0, holeY = 0);
      
    translate([0, 0, 0]) cylinder(90, d = DIAMETER, $fn = 32); 
    
  } 
}

*group() {
  holder(20, 1, 20, DIAMETER / 3.9, diameter = 40, hole = true, parts = 16, holeX = 0, holeY = 0);
  
  translate([26, 28, 0])
    holder(40, 1, 10, DIAMETER / 2.8, diameter = 40, diameter = 10, hole = false, parts = 8, holeX = 0, holeY = 0);
  
  translate([30, 8, 0])
    holder(20 , 1, 8, DIAMETER / 3.8, diameter = 40, diameter = 10, hole = false, parts = 3, holeX = 0, holeY = 0);
}
  

*group() {
  translate([0, 0, 0])
    holder(80, 4, 10, DIAMETER / 2.9, hole = true, parts = 6, holeX = 0, holeY = 0);
  
  translate([45, 0, 0])
    holder(60, 4, 10, DIAMETER / 2.9, hole = true, parts = 10, holeX = 0, holeY = 0);
  
  translate([90, 0, 0])
    holder(40, 4, 10, DIAMETER / 2.9, hole = true, parts = 16, holeX = 0, holeY = 0);
  
  
  translate([0, 45, 0]) {
    translate([0, 0, 0])
    holder(100, 2, 10, DIAMETER / 2.9, hole = true, parts = 6, holeX = 0, holeY = 0);
  
  translate([45, 0, 0])
    holder(100, 4, 10, DIAMETER / 2.9, hole = true, parts = 10, holeX = 0, holeY = 0);
  
  translate([90, 0, 0])
    holder(100, 6, 10, DIAMETER / 2.9, hole = true, parts = 16, holeX = 0, holeY = 0);
  }
  
  translate([0, -45, 0]) {
    translate([0, 0, 0])
    holder(20, 1, 10, DIAMETER / 2.9, hole = false, parts = 6, holeX = 0, holeY = 0);
  
  translate([45, 0, 0])
    holder(20, 1, 10, DIAMETER / 2.9, hole = false, parts = 10, holeX = 0, holeY = 0);
  
  translate([90, 0, 0])
    holder(20, 1, 10, DIAMETER / 2.9, hole = false, parts = 16, holeX = 0, holeY = 0);
  }
}