CORNER_RADIUS = 4;
WIDTH = 40;
HEIGHT = 20;
LW = 0.4;
T_WIDTH = 5;

module ductSpiral(size = [WIDTH, HEIGHT], r = CORNER_RADIUS, texture = false, tWidth = T_WIDTH, mults = [1, 1], shifts=[false, false]) {
  w = size[0];
  h = size[1];
  
  difference() {
    union() {
      for (x = [r, w - r])
        for (y = [r, h - r])
          translate([x, y])
            circle(r, $fn = 32);
        
      translate([0, r])
        square([w, h - r * 2]);
      
      translate([r, 0])
        square([w - r * 2, h]);    
    }
    
    if (texture) {
      wMax = (w - r * 2);
      hMax = (h - r  * 2);
      
      wShift = -r / 2; // shifts[0] != false ? shifts[0] : floor(wMax / 8) % 2 == 0 ? 0 : -r / 2;
      hShift = -r / 2; // shifts[1] != false ? shifts[1] : floor(hMax / 8) % 2 == 0 ? 0 : -r / 2;
      
      for (y = [0, 1])
        translate([wShift, h * y])
          mirror([0, y])
            polygon([
              for(t = [r : .4 : wMax])
                [
                  t * mults[1], 
                  (.25 * mults[0]) - cos(t * 90) / (4 / mults[0])
                ]
            ]);

      for(x = [0, 1])
        translate([w * x, hShift])
          mirror([x, 0])
            polygon([
              for(t = [r : .4 : hMax])
                [
                  (.25 * mults[0]) - cos(t * 90) / (4 / mults[0]), 
                  t * mults[1]
                ]
            ]);
    }
  }
}

module ductTaper(size = [WIDTH, HEIGHT], h = 5, r = CORNER_RADIUS, texture = false, tWidth = T_WIDTH, mults = [1, 1], offset = LW * 2) {
  difference() {
    hull() {
      linear_extrude(h) 
        offset(offset) 
          ductSpiral(size = size, r = r, texture = texture, tWidth = tWidth, mults = mults);
      
      translate([0, 0, h])
        linear_extrude(tWidth * 5) 
          offset(-tWidth) 
            ductSpiral(size = size, r = r, texture = texture, tWidth = tWidth, mults = mults);
    }
    
    translate([0, 0, h + tWidth * 2.5])
      linear_extrude(tWidth * 4)
        translate(-.5 * size)
          square(size * 2);
  }
}

// TEST 1
*group() {
  ductTaper(h = 5);
  
  linear_extrude(20) ductSpiral(texture = true);

  translate([0, HEIGHT, 20])
    rotate([0, 180, 180]) ductTaper(offset = 0);
}

group() {
  ductTaper(size = [92, 92], h = 18);
  
  translate([0, 0, 18]) 
    linear_extrude(20) 
      ductSpiral(size = [92, 92], texture = true, mults = [2, 2]);
  
  translate([0, 92, 38])
    rotate([0, 180, 180]) ductTaper(size = [92, 92], offset = 0, h = 1);
  
  translate([0, 0, 38]) {
    hull() {
      linear_extrude(0.1) ductSpiral(size = [92, 92]);
      translate([0, 0, 60]) linear_extrude(0.1) ductSpiral(size=[92, 36]);
    }
  }
  
  translate([0, 0, 98])
     ductTaper(size = [92, 36], offset = 0 , h = 0.1,  mults = [2, 2]);
  
  translate([0, 0, 98])
     linear_extrude(20) ductSpiral(size = [92, 36], texture = true,,  mults = [2, 2], shifts = [false, -CORNER_RADIUS / 2]);
  
  
  translate([0, 36, 98 + 25])
    rotate([0, 180, 180]) ductTaper(size = [92, 36], offset = 0, h = 10);
}