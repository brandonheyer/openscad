thickness = 3;
theta = 360/8;
c = 2 * 3.414 * 20.8;
d = 20.8 * tan(theta / 2);

linear_extrude(15) {
  for (i = [theta : theta : 360]) {
      translate([-(d + thickness * tan(theta / 2) * 2) - 0.4 + i / theta * (d + thickness * tan(theta / 2) * 2 + 0.4), 0, 0])
    difference() {
        polygon([
          [0, 0],
          [thickness * tan(theta / 2), thickness],
          [d + thickness * tan(theta / 2), thickness],
          [d + thickness * tan(theta / 2) * 2, 0]
        ]);
      
          translate([
        (d + thickness * tan(theta/2)*2) /2,
        12.4
      ]) circle(d=20.8, $fn = 64);
    }
  }

  translate([0, -0.4]) square([(d + thickness * tan(theta / 2) * 2) * 8 + (0.4 * 7), 0.4]);
}
