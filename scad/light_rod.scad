INSET = -0.4;

XS = [1, 4, 10, 13];
YS = [0, 3, 5];
H = YS[2] - YS[0];
W = XS[3] - XS[0];

module base() {
  polygon([
    [XS[1], YS[0]],
    [XS[2], YS[0]],
    [XS[3], YS[1]],
    [XS[3], YS[2]],
    [XS[2], YS[1]],
    [XS[1], YS[1]],
    [XS[0], YS[2]],
    [XS[0], YS[1]]
  ]);
}

*rotate([0, 90, 0])
translate([-(8.5 - (17 - (W * 1.2)) / 2), 15, 0]) linear_extrude(10)
difference() {
  translate([8.5 - (17 - (W * 1.2)) / 2, 0, 0]) color("red") circle(d = 17, $fn = 64);
  scale(1.2) translate([-1, -5.25, 0]) base();
  mirror([0, 1, 0]) scale(1.2) translate([-1, -5.25, 0]) base();
}
*rotate([0, 90, 0])
translate([-(8.5 - (17 - (W * 1.1)) / 2), 52, 0]) linear_extrude(10)
difference() {
  translate([8.5 - (17 - (W * 1.1)) / 2, 0, 0]) color("red") circle(d = 17, $fn = 64);
  scale(1.1) translate([-1, -5.5, 0]) base();
  mirror([0, 1, 0]) scale(1.1) translate([-1, -5.5, 0]) base();
}

*rotate([0, 90, 0])
translate([20, 34, 0])
linear_extrude(10)
group() {
  difference() {
    circle(d = 17, $fn = 64);
    circle(d = 14.6, $fn = 32);
  }
  
  translate([0, 0, 0]) circle(d = 4, $fn = 32);
  translate([-8.4, -.6, 0]) square([16.8, 1.2]);
}

rotate([180, 270, 0]) translate([20, -34, 0])
linear_extrude(30)
group() {
  difference() {
    circle(d = 17, $fn = 12);
    circle(d = 13.8, $fn = 12);
    rotate([0, 0, 93]) square([20, 8], center = true);
    rotate([0, 0, 87]) square([20, 8], center = true);
  }
  
  translate([-8, -1.2, 0]) square([16, 2.4]);
}