include <constants.scad>;

screwHole = 2.5;

module screwSlicer(
  t = [0, 0, 0],
  r = [0, 0, 0], 
  h = 5, 
  sh = 15, 
  d = WASHER_D, 
  sd = SCREW_D,
  t2 = [0, 0, 0]
) {
  translate(t) 
    rotate(r)
      translate(t2) {
      cylinder(h = h, d = d, $fn = 32);
      
      translate([0, 0, -sh])
        cylinder(h = sh + 1, d = sd, $fn = 32);
    }
}