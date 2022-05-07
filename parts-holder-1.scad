include <../3d-random/pipe-fittings.scad>;

module threeQuarterHolder() {
  difference() {
    cylinder(h = 4, d = 38, $fn = 12);
    
    translate([0, 0, -0.2])
      npt(size = 0.75, internal = false, test = $preview, length = 3/16);
  }
}

module oneInchHolder() {
    difference() {
    cylinder(h = 4, d = 45, $fn = 12);
    
    translate([0, 0, -0.2])
      npt(size = 1, internal = false, test = $preview, length = 3/16);
  }
}

for(x = [0 : 1 : 2]) 
  for(y = [0 : 1: 2]) 
    translate([x * 48, y * 48, 0]) {
        if (x != 0) {
          translate([            
            (x - y == 1) ? - 30 : -34, 
            -3, 
            0
          ])
            cube([
              (x == y || x - y == 1) ? 16 : 20, 
              6, 
              4
            ]);
        }
        
        if (y != 0) {
          rotate([0, 0, 90]) 
            translate([
              (x - y == -1) ? - 30 : -34, 
              -3, 
              0
            ]) 
              cube([
                (x == y || (x - y == -1)) ? 16 : 20, 
                6, 
                4
              ]);
        }
        
     if (x == y) {
       oneInchHolder();
     }
     else {
       threeQuarterHolder();
     }
  }