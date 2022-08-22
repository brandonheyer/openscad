B = 1.6;
HB = B / 2;
DSTEP = 360 / 11;
OD = 13;

linear_extrude(3.4) {
  for (i = [0 : 1 : 10]) {
    rotate([0, 0, DSTEP * i])
      translate([0, 1.65, 0])
        polygon([
          [0, 0.2],
          [0, 0.6],
          [HB, 1.5],
          [-HB, 1.5],
          [0, 0.6],
          [0, 0.2]
        ]);
  }

  difference() {
    $fn = 32;
    
    circle(d = OD);
    circle(d = 5.8);    
  }
}

module tread() { 
  for (i = [0 : 1 : 15]) {
    rotate([0, 0, i * 360 / 16])
      translate([0, OD / 2 - 0.8, 0])
        polygon([
          [1.4, 0],
          [0.8, 1.2],
          [-0.8, 1.2],
          [-1.4, 0]
        ]);
  }
}

linear_extrude(8) {
  tread();
 
  difference() {
    $fn = 64;
    
    circle(d = OD);
    circle(d = 10.1);    
  }
}

translate([0, 0, -0.8])
linear_extrude(0.8) {
  tread();
 
  $fn = 64;
    
  difference() {
    $fn = 64;
    
    circle(d = OD);
    circle(d = 2);    
  }
}