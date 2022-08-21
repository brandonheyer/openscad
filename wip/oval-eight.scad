HEIGHT = 42;
DIAMETER = 21.6;
OUTER_DIAMETER = 28;
O_THICKNESS = 8;
THICKNESS = 2.8;

TUBE_OUTER_Y_SCALE = 1.05;

$fn = $preview ? 32 : 128;

module tube(h, od, thickness, sc = [1, TUBE_OUTER_Y_SCALE, 1]) {
  difference() {
    scale(sc)
    cylinder(h = h, d = od + thickness, center = true);
   
    cylinder(h = h + 1, d = od, center = true);
  }
}

module upper() {
  intersection() {
    difference() {
      tube(HEIGHT, DIAMETER, THICKNESS);
      
      translate([OUTER_DIAMETER / 2, 0, 0])
        sphere(d = OUTER_DIAMETER);
    }
    
    translate([OUTER_DIAMETER / 2, 0, 0])
      sphere(d = OUTER_DIAMETER + O_THICKNESS);
  }
}

module basic() {
  upper();

  difference() {
    tube(5, DIAMETER, THICKNESS);
    
    translate([DIAMETER * .75 * 1.2, 0, 0])
      cube(DIAMETER * 1.5, center = true);
  }
}

module uppertwo() {
  difference() {
    upper();
    cube([O_THICKNESS / 2, HEIGHT, HEIGHT], center = true);
    
    translate([O_THICKNESS * .875, 0, 0])
      cube([O_THICKNESS * .7, DIAMETER * 1.5, RING_HEIGHT], center = true);
  }
}

uppertwo();

RING_HEIGHT = 3;
*difference() {
  union() {
    tube(RING_HEIGHT, DIAMETER + 0.01, THICKNESS * .75, 1);
    
    rotate([0, 0, 76])
    translate([(DIAMETER + THICKNESS / 2) / 2, 0, 0])
    scale([1.1, 1.5, 1])
      cylinder(h = RING_HEIGHT, d = 4, center = true);
  
    rotate([0, 0, -76])
    translate([(DIAMETER + THICKNESS / 2) / 2, 0, 0])
    scale([1.1, 1.5, 1])
      cylinder(h = RING_HEIGHT, d = 4, center = true);
  
  }
  
    cylinder(h = RING_HEIGHT + 2, d = DIAMETER + 0.1, center = true);
    uppertwo();
}