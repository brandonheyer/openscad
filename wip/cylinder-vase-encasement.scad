

module piece() {
  rotate([0, 0, 0])
  linear_extrude(150, twist =  360, slices = 14)
  rotate([0, 20, 90])
  translate([28, 0, 0])
  circle(r = 5, $fn = 16);
}

module piece2(r = 12, x = 30, yr = -5, twist = 180) {
  rotate([0, yr, 0])
  linear_extrude(150, twist = twist, slices = 30)
  rotate([0,0,90])
  translate([x, 0, 0])
  circle(r = r, $fn = 32);
}

difference() {
  group() {
    rotate([0, 0, 0]) {
      for(i = [0 : 45 : 360]) {
        rotate([0, 0, i]) {
          piece2(18, 20, -2, 90);
          
*          rotate([0, 0, 30])
            piece2(10, 30, 5, 360);
         
        }
      }
    }
  }
  

  translate([0, 0, 5])
    cylinder(150, 29, 29, $fn = 64);
  
  translate([0, 0, -10])
    cylinder(10, 100, 100);
}

translate([0, 0, 0])
  cylinder(8, 30, 30, $fn = 128);