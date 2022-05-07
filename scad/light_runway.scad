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

difference() {
  translate([8.5 - 2.5, 8.5 - 2.5, 0]) {
    intersection() {
      circle(d=17);
      square([17, 10], center = true);
    }
  }
translate([-2.375, 0, 0]) {
    translate([0, -1, 0]) scale(1.2)  base();
    translate([0, 13 ,0]) mirror([0, 1, 0]) scale(1.2) base();
  }
}