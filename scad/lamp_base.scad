linear_extrude(8) {
  difference() {
    square([24, 105], center = true);

    translate([0, -59, 0])  for (i = [0.1 : 0.1 : 0.5])
      translate([0, i * 200, 0]) {
        offset(i) {
          difference() {
            circle(d = 17, $fn = 12);
            circle(d = 13.8, $fn = 12);
            rotate([0, 0, 93]) square([20, 8], center = true);
            rotate([0, 0, 87]) square([20, 8], center = true);
          }
          
          translate([-8, -1.2, 0]) square([16, 2.4]);
      }
    }
  }
}

translate([0, 0, 0])
linear_extrude(8) {
  difference() {
    square([24, 105], center = true);

    translate([0, -59, 0])  for (i = [0.1 : 0.1 : 0.5])
      translate([0, i * 200, 0]) offset(0) {
        difference() {
          circle(d = 17, $fn = 12);
        }
        
        translate([-8, -1.2, 0]) square([16, 2.4]);
      }
  }
}