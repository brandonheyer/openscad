*group() {
  h = 2.8;
  o = 4;
  i = 5;
  fn = 16;

  difference() {
    cylinder(h, o, i + .4, $fn = fn);
    translate([0, 0, .28 * 2]) 
      cylinder(h - .28 * 1.9, o - (.28*4), i - (.28*4), $fn = fn);
  }

  translate([0,0, h])
  difference() {
    sphere(i, $fn = fn);
    scale([.75, .75, .75]) sphere(i, $fn = fn);
    translate([0, 0, i * -1.5]) cube(i * 3, center = true);
    translate([0, 0, i * 1.5])
      sphere(i, $fn = fn);
  }
}

cylinder(4, 4, 4, $fn = 64);