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
module boltlessPeg(
  h = 11.5,
  t = THICKNESS,
  pegScale = [1, 1, 1]
) {
  r1 = PEG_INNER_RADIUS;
  r2 = PEG_OUTER_RADIUS;
  minH = MIN_H;
  
  h1 = boltlessPegOffset(h);            
  h2 = h - minH;
  h3 = h;
  
  rotate([90, 0, 90]) {
    $fn = $preview ? 16 : 128;    
    cylinder(h1, r2, r2);
    
    translate([0, 0, h1])
      cylinder(h2 - h1, r1, r1);
    
    translate([0, 0, h2])
      scale(pegScale)
        cylinder(h3 - h2, r2, r2);
  }
}

LINE_WIDTH = 0.4;
LAYER_HEIGHT = 0.2;

/**
 * Create a boltless ring holder, with optional base
 */
module boltlessHolder(
  d = 58, 
  pegHeight = 11.5,
  pegXOffset = 11,
  ringHeight = PEG_OUTER_RADIUS * 2, 
  ringThickness = LINE_WIDTH * 10,
  centerRing = true,
  base = false,
  baseHeight = 2.4,
  innerFn = 128,
  outerFn = 256,
  pegFn = 128,
  baseScale = [2, 1, 1]
) {
  r = d / 2 + pegXOffset;
  halfHeight = ringHeight / 2;

  pegD = PEG_OUTER_RADIUS * 2;
  pegOffset = boltlessPegOffset(pegHeight);
  
  zOffset = abs(pegD - ringHeight) / 2;
  
  cd = d + ringThickness;
  cr = cd / 2;
  h1 = LAYER_HEIGHT * 8;
  h2 = ringHeight - h1 * 2;
  r1 = cr - LINE_WIDTH * 2;
  ofn = $preview ? outerFn / 4 : outerFn;
  pfn = $preview ? pegFn / 8 : pegFn;
  
  // PEG
  translate([r, 0, PEG_OUTER_RADIUS]) 
    boltlessPeg(pegHeight);

  // HOOP
  translate([0, 0, zOffset])
    difference() {
      // HOOP: OUTER SHELL
      hull() {
        tz = centerRing ? 0 : -zOffset;        
        
        translate([0, 0, tz]) {
          cylinder(h1, r1, cr, $fn = ofn);
          
          translate([0, 0, h1])
            cylinder(h = h2, d = cd, $fn = ofn);
          
          translate([0, 0, h1 + h2])
            cylinder(h1, cr, r1, $fn = ofn);
        }
            

        // Need to reset z-translation here
        translate([r, 0, halfHeight])
          rotate([90, 0, 90])
            scale(baseScale)              
              cylinder(
                h = pegOffset, 
                d = pegD, 
                $fn = pfn
              );
      }

      // HOOP: SLICER
      sliceOffset = 1 + zOffset * 2;
      translate([0, 0, -sliceOffset / 2]) 
        linear_extrude(sliceOffset + ringHeight)
          circle(d = d, $fn = innerFn);
    }

  // HOOP: BASE
  if (base) {
    linear_extrude(baseHeight)
      circle(d = d + 0.1, $fn = outerFn);
  }
}
 

boltlessHolder(
  20.8,
  ringHeight = 5,
  ringThickness = 3,
  centerRing = false, 
  pegXOffset = 6,
  pegHeight = 6,
  baseScale = [1, 1, 1]
);

// LARGE CYLINDER VASE
*group() {
  *boltlessHolder();
  //translate([105, 0, 0]) 
    //rotate([0, 0, 180]) 
      boltlessHolder(base = true);
}