W = 40;
H = 30;
LT = 0.4;
LH = 0.16;
A = 1.5;

SHAPE = [
  [0, 0],
  [0, W * .1],
  [A, W * .1 + A],
  [A, W * .4 - A], 
  [0, W * .4],
  [0, W * .6],
  [A, W * .6 + A],
  [A, W * .9 - A], 
  [0, W * .9],
  [0, W],
  [W * .3, W],
  [W * .3 + A, W - A],
  [W * .7 - A, W - A],
  [W * .7, W],
  [W, W],
  [W, W * .9],
  [W - A, W * .9 - A],
  [W - A, W * .6 + A], 
  [W, W * .6],
  [W, W * .4],
  [W - A, W * .4 - A],
  [W - A, W * .1 + A], 
  [W, W * .1],
  [W, 0]
];

SHAPE2 = [
  [0, 0],
  [0, W],
  [W, W],
  [W, 0]
];

*difference() {
  cube([40, 40, 30], center = true);
  translate([0, 0, H * 2])
    cube([40 - 2 * T, 40 - 2 * T, 30], center = true);
}

translate([0, 0, LH * -3])
  linear_extrude(LH * 3)
    offset(delta = LT) 
      polygon(SHAPE);

difference() {
  translate([0, W, 0])
    linear_extrude(10, scale = [1, 1.2], slices = 40)
      translate([0, -W, 0]) 
        difference() {
          offset(delta = LT)
            polygon(SHAPE2);
          
          polygon(SHAPE2);
        }
  translate([-A * 2, 0, -2]) cube(50);
}

upper(10, 0, shiftY = W, shape = SHAPE);
upper(10, 10, shiftY = W);
upper(1, 20, shiftX = W / 2, shiftY = W / 2, scale = [1.05, 1.05]);
upper(1, 21, shiftX = W / 2, shiftY = W / 2, scale2 = [1.05, 1.05 * 1]);
      
module upper(h, last, scale = 1, shiftX = 0, shiftY = 0, scale2 = [1, 1], shape = SHAPE) {   
translate([shiftX, shiftY, last])
  linear_extrude(h, scale = scale)
    scale(scale2) 
      translate([-shiftX, -shiftY, 0]) 
        difference() {
          offset(delta = LT) 
            polygon(shape);

          polygon(shape);
          polygon([
            [0, -1],
            [0, 1],
            [W, 1],
            [W, -1]
          ]);
        }
}