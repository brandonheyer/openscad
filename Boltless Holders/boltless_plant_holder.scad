MIN_H = 3;
THICKNESS = 1.5;
PEG_OUTER_RADIUS = 5.5;
PEG_INNER_RADIUS = 3.5;

/**
 * Return the x-offset to the groove in the peg
 */
boltlessPegOffset = function (h = 11.5) h - MIN_H - THICKNESS;  
 
/**
 * Creates a peg for usage in boltless shelving uprights
 */
module boltlessPeg(h = 11.5) {
  t = THICKNESS;
  r1 = PEG_INNER_RADIUS;
  r2 = PEG_OUTER_RADIUS;
  minH = MIN_H;
  
  h1 = boltlessPegOffset(h);            
  h2 = h - minH;
  h3 = h;
  
  poly = [
    [0,  0],
    [r2, 0],
    [r2, h1],
    [r1, h1],
    [r1, h2],
    [r2, h2],
    [r2, h3],
    [0,  h3]
  ];
    
  rotate([90, 0, 90])
    rotate_extrude(angle = 360, $fn = 64) 
      polygon(poly);
}

/**
 * Create a boltless ring holder, with optional base
 */
module boltlessHolder(
  d = 58, 
  pegHeight = 11.5,
  pegXOffset = 11,
  ringHeight = PEG_OUTER_RADIUS * 2, 
  ringThickness = 5,
  centerRing = true,
  base = false,
  baseHeight = 2.4,
  innerFn = 128,
  outerFn = 128,
  pegFn = 128
) {
  r = d / 2 + pegXOffset;
  halfHeight = ringHeight / 2;

  pegD = PEG_OUTER_RADIUS * 2;
  pegOffset = boltlessPegOffset(pegHeight);
  
  zOffset = abs(pegD - ringHeight) / 2;
  
  // PEG
  translate([r, 0, PEG_OUTER_RADIUS]) 
    boltlessPeg(pegHeight);

  // HOOP
  translate([0, 0, zOffset])
    difference() {
      // HOOP: OUTER SHELL
      hull() {
        translate([0, 0, centerRing ? 0 : -zOffset]) 
          linear_extrude(ringHeight)
            circle(d = d + ringThickness, $fn = outerFn);

        // Need to reset z-translation here
        translate([r, 0, halfHeight])
          rotate([90, 0, 90]) 
            cylinder(h = pegOffset, d = pegD, $fn = pegFn);
      }

      sliceOffset = 1 + zOffset * 2;
      
      // HOOP: SLICER
      translate([0, 0, -sliceOffset / 2]) 
        linear_extrude(sliceOffset + ringHeight)
          circle(d = d, $fn = innerFn);
    }

  // HOOP: BASE
  if (base) {
    linear_extrude(baseHeight)
      circle(d = d + ringThickness, $fn = outerFn);
  }
}
 

boltlessHolder(20.8, ringHeight = 5, ringThickness = 3, centerRing = false, pegXOffset = 6, pegHeight = 6);

// LARGE CYLINDER VASE
*group() {
  boltlessHolder();
  translate([80, -40, 0]) 
    rotate([0, 0, 180]) 
      boltlessHolder(base = true);
}