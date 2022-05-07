include <./constants.scad>;
use <./library.scad>;
// 2 are 15.5mm


module base(l, w, h, padding = 2) {
  length = l;
  width = w;
  height = h;
  halfLength = length / 2;
  halfWidth = width / 2;
  railSize = MARBLE_RADIUS * 1.3;
  railZ = railSize * cos(22.5);
  widthEdge = halfWidth - (cos(22.5) * railSize);
  lengthEdge = halfLength - (cos(22.5) * railSize);
  widthEdgeRailLength = length - (railZ * 4);
  lengthEdgeRailLength = width - (railZ * 4);

  difference() {
    cube([length, width, height], center = true);

    translate([0,0,.5]) {
      translate([lengthEdge - railZ, widthEdge - railZ, railSize * cos(22.5)])
        rotate_extrude(angle = 90, convexity = 2, $fn = 12)
          translate([railSize * cos(22.5), 0, 0])
            rotate([0, 0, 22.5])
              circle(railSize, $fn = 8);
      
      translate([-lengthEdge + railZ, widthEdge - railZ, railSize * cos(22.5)])
        rotate([0,0,180])
          rotate_extrude(angle = -90, convexity = 2, $fn = 12)
            translate([railSize * cos(22.5), 0, 0])
              rotate([0, 0, 22.5])
                circle(railSize, $fn = 8);
      
      translate([lengthEdge - railZ, -widthEdge + railZ, railSize * cos(22.5)])
        rotate_extrude(angle = -90, convexity = 2, $fn = 12)
          translate([railSize * cos(22.5), 0, 0])
            rotate([0, 0, 22.5])
              circle(railSize, $fn = 8);
              
          
      translate([-lengthEdge + railZ, -widthEdge + railZ, railSize * cos(22.5)])
        rotate([0,0, 180])
          rotate_extrude(angle = 90, convexity = 2, $fn = 12)
            translate([railSize * cos(22.5), 0, 0])
              rotate([0, 0, 22.5])
                circle(railSize, $fn = 8);

      translate([lengthEdge, 0, railZ])
        rotate([90, 0, 0])
          linear_extrude(lengthEdgeRailLength, center = true)
              rotate([0, 0, 22.5])
                circle(railSize, $fn = 8);
      
      translate([-lengthEdge, 0, railZ])
        rotate([90, 0, 0])
          linear_extrude(lengthEdgeRailLength, center = true)
              rotate([0, 0, 22.5])
                circle(railSize, $fn = 8);
      
      translate([0, -widthEdge, railZ])
        rotate([90, 0, 90])
          linear_extrude(widthEdgeRailLength, center = true)
              rotate([0, 0, 22.5])
                circle(railSize, $fn = 8);
      
      translate([0, widthEdge, railZ])
        rotate([90, 0, 90])
          linear_extrude(widthEdgeRailLength, center = true)
              rotate([0, 0, 22.5])
                circle(railSize, $fn = 8);
    }
  
    translate([lengthEdge, 0, -.25])
      compassHolder(5, slicer = true);
      
    translate([0, widthEdge, -.25])
      compassHolder(5, slicer = true);
      
    translate([-lengthEdge, 0, -.25])
      compassHolder(5, slicer = true);
      
    translate([0, -widthEdge, -.25])
      compassHolder(5, slicer = true);
     
    translate([(length - 28) / -2, (width - 28) / -2, -1.1])
      plugs(10, (length - 20) / 10, (width - 20) / 10, false, false) {
        cylinder(5, 2.25, 2.25, $fn = 8);
      }
    
    translate([-lengthEdge + 2, -widthEdge + 2, -5]) screwHole();
    translate([lengthEdge - 2, -widthEdge + 2, -5]) screwHole();
    translate([lengthEdge - 2, widthEdge - 2, -5]) screwHole();
    translate([-lengthEdge + 2, widthEdge - 2, -5]) screwHole();
  }

  translate([(length - 28) / -2, (width - 28) / -2, -1])
    plugs(10, (length - 20) / 10, (width - 20) / 10, false, false, false);
}


base(100, 60, 4);
