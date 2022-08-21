HEIGHT = 18;
SEPARATION = .8;

for (i = [10 + (1 + SEPARATION)  : 1 + SEPARATION : 25])
  rotate_extrude(angle = 360, $fn = 96)
    translate([0, 0, 0])
      difference() {
        circle(r = i, $fn = 64);
        circle(r = i - 1.4, $fn = 64);
        
        translate([0, -i * 5, 0]) square([i * 10, i * 10]);

        translate([-i * 5, -i * 10 - HEIGHT / 2, 0]) square([i * 10, i * 10]);
        translate([-i * 5, HEIGHT / 2, 0]) square([i * 10, i * 10]);
      }
      
      
      