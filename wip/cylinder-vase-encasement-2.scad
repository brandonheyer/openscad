difference() {
   multmatrix(m = [ 
    [1, 0, 0, 0],
    [0, 1, 0, 0],
    [0, 0, 1, 0],
    [0, 0, 0, 1]
  ])
  linear_extrude(70, twist = 90, slices = 150)
    circle(r = 45, $fn = 6);
  
  translate([0, 0, 10])
    cylinder(155, 29, 29, $fn = 64);
}
