TSIDE = 18;
SIDE = 9;
SMOOTH = .4;
SQRT22 = sqrt(2) / 2;
SIDESQ22 = SIDE * SQRT22;
WALL_WIDTH = 1.6;
WALL_OVERLAP = WALL_WIDTH / 4 * 3;

module hexagon(side, offset = 0) {
  s = side - offset;
  
  offset(r = offset, $fn = 32)
    union()
      for(i = [0 : 1 : 6]) 
        rotate([0, 0, i * 60])
            polygon([
              [0, 0], 
              [s / 2, s * sqrt(3) / 2],
              [s / -2, s * sqrt(3) / 2]
            ]);
    
}

module octagon(side, offset = 0) {
  s = side - offset;
  
  offset(r = offset, $fn = 32)
    union()
      for(i = [0 : 1 : 7]) 
        rotate([0, 0, i * 45])
            polygon([
              [-s * cos(135 / 2), s * sin(135 / 2)], 
              [s * cos(135 / 2), s * sin(135 / 2)],
              [0, 0]
            ]);
    
}

module hexa() {
  difference() {
    octagon(SIDE + WALL_WIDTH, SMOOTH);
    octagon(SIDE, SMOOTH);
  }
}

linear_extrude(5) {
  s = SIDE + (SMOOTH / 2) + WALL_WIDTH;
  ty = (sqrt(2) * s / 2) + (s / 2);
  
  rotate([0, 0, 0]) translate([0, ty, 0]) hexa();
  rotate([0, 0, 90]) translate([0, ty, 0]) hexa();
  rotate([0, 0, 180]) translate([0, ty, 0]) hexa();
  rotate([0, 0, 270]) translate([0, ty, 0]) hexa();
}