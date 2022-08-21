*difference() {
  translate([0,0,12])
    rotate_extrude(angle = 360, $fn = 64)
      polygon([
        [36, 0],
        [36, 35],
        [52, 60],
        [58, 62],
        [58, 12],
        [55, 5],
        [55, 0]
      ]);
  
  linear_extrude(90)
    polygon([
      [0, 0],
      [90 * cos(45), 90 * sin(45)],
      [90 * cos(-45), 90 * sin(-45)]
  ]);
 
}

difference() {
  rotate_extrude(angle = 360, $fn = 128) 
    polygon([
      [0, 0],
      [0, 10],
      [55.4, 16],
      [56, 21],
      [58, 21],
      [58, 13],
      [56.5, 8],
      [55, 5],
      [51, 0]
    ]);
    
  translate([-2, 0, 48])
    rotate([115, 0, 90])  
      scale([1.8,1,1])
        cylinder(h = 100, r1 = 39.7, r2 = 8, $fn = 128);
  
  translate([52, 0, -3])
    rotate([-15, 0, 90])
      scale([4.5, 2.2, 1])
        cylinder(h = 20, r1 = 4, r2 = 8, $fn = 64);
  
  translate([42, 0, 1]) {
    slot();
    
    translate([5 * cos(10), -25 * sin(10), 0])
      rotate([0, 0, 10])
        slot();
    
    translate([5 * cos(10), 25 * sin(10), 0])
      rotate([0, 0, -10])
        slot();
    
      translate([5 * cos(20), -25 * sin(20), 0])
      rotate([0, 2.5, 20])
        slot();
    
    translate([5 * cos(20), 25 * sin(20), 0])
      rotate([0, 2.5, -20])
        slot();
  }
}

module slot() {
  rotate([0, 2, 0])
  scale([5, 1, 1])
  difference() {
      cylinder(h = 8, r1 = 1, r2 = 10, $fn = 32);
      translate([0,-12,-1]) cube([10, 25, 20]);
    }
  }