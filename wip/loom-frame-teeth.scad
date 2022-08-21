TOOTH_WIDTH = 2;
TOOTH_DEPTH = 4;
BAR_DEPTH = 1;
TOOTH_SPACING = 1;
TEETH = 10 ;
H = 4;
L = TOOTH_WIDTH * TEETH + TOOTH_SPACING * TEETH - 1;

difference() {
  union() {
    for (i = [0 : 1 : TEETH - 1]) {
      translate([
        0, 
        i * TOOTH_WIDTH + i * TOOTH_SPACING,  
        0
      ])
        cube([
          TOOTH_DEPTH + BAR_DEPTH, 
          TOOTH_WIDTH, 
          H
        ]);
    }

    cube([
      BAR_DEPTH + TOOTH_DEPTH,
      L,
      H / 2
    ]);
  }

  translate([-H / 2 * sin(30), -0.5, H / 1.33])
    rotate([90, 0, 180])
      cylinder(L + 1, d = H, $fn = 6);
}