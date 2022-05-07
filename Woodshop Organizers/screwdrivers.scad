PHILLIPS_SIZES = [
  [6, 30, true],
  [6, 30, true],
  [6, 30, true],
  [3, 16, false],
  [5, 30, true],
  [3, 16, false],
  [3, 20, false]
];

FLAT_SIZES = [
  [
    [[8, 14.5], 32, true],
    [[6, 10.5], 29, true, -1.5 + 1],
    [[6, 10.5], 29, true, 1],
    [[5, 8.7], 25, true, 1], 
    [[5, 8.7], 25, true, 1],
    [[5, 6.1], 25, false, 1]
  ],
  [
    [[5, 14], 30, true, -137.5 + 25 / 2 - 3.5, -3.75],
    [[3, 5.1], 19, true, 0, .75],
    [[3, 5.3], 15, true, 1, 4.75],
    [[3, 3.4], 15, false, 1, 4.75],

  ]
];

FLAT_DIAMETERS = [for(i = FLAT_SIZES) [ for(j = i) j[0][0]]];
FLAT_MAXES = [for(i = FLAT_DIAMETERS) max(i)];

TORX_SIZES = [

];

module holeSlicer(sizes, x = 0, lastOffset = 0, xScale = 1) {
  maxSize = max([for(i = sizes) i[1]]);
  hole = sizes[x];
  
  if (hole) {
    yShift = is_undef(hole[4]) ? 0 : hole[4];
    translate([lastOffset, yShift -maxSize / 2 - (maxSize - hole[1]) / 2, 0]) {
      if (is_list(hole[0])) {
        if (hole[2] == true) {
          hull() {
            rotate([0, 0, 45]) 
              square(hole[0][0] * xScale, center = true);

            square([hole[0][1] * xScale, hole[0][0] / 2], true);
          }
        } else {
          hull() {
            circle(d = hole[0][0] * xScale);
            square([hole[0][1] * xScale, hole[0][0] / 2], true);
          }
        }                
      } else {
        if (hole[2] == true) {
          square(hole[0] * xScale, center = true);
        } else {
          circle(d = hole[0] * xScale);
        }
      }
      
      %circle(d = hole[1]);
    }
      
    if (x < len(sizes) - 1) {
      shift = is_undef(sizes[x + 1][3]) ? 0 : sizes[x + 1][3];
      holeSlicer(sizes, x + 1, lastOffset + (xScale * (sizes[x][1] / 2 + sizes[x + 1][1] / 2 + shift)));
    }
  }
}

linear_extrude(.28 * 5) hullDifference(12) {
  holeSlicer(FLAT_SIZES[0], 0, 0, 1.05);
}
linear_extrude(.28 * 5) hullDifference(12) {
  mirror([1,0,0]) translate([0, 25.5, 0]) 
    holeSlicer(FLAT_SIZES[1], 0, is_undef(FLAT_SIZES[1][0][3]) ? 0 : FLAT_SIZES[1][0][3], 1.05);
}

module hullDifference(offset = 0) {
  difference() {
    offset(r = offset) 
      hull()
        children();

    children();
  }
}

module screwDriverHoleSlicer(
  holes = [], 
  rowIndex = 0, 
  holeIndex = 0, 
  xOffset = 10, 
  yOffset = 10, 
  minSpacing = 3, 
  holeMax = 0,
  expand = false,
  reverse = false,
  scalar = 1.1
) {
  if (rowIndex < len(holes)) {
    row = holes[rowIndex]; 
    
    if (holeIndex < len(row)) {
      hole = row[holeIndex];
      
      translate([xOffset, hole[1] / 2, 0]) {
        if (expand) {
          circle(d = hole[1] * expand);
        } else {
          if (is_list(hole[0])) {
            if (hole[2] == true) {
              hull() {
                rotate([0, 0, 45]) 
                  square(hole[0][0] * scalar, center = true);

                square([hole[0][0] * 2, hole[0][0] / 1.5], true);
              }
            } else {
              hull() {
                circle(d = hole[0][0] * scalar);
                square([hole[0][0] * 2, hole[0][0] / 1.5], true);
              }
            }                
          } else {
            if (hole[2] == true) {
              square(hole[0] * scalar, center = true);
            } else {
              circle(d = hole[0] * scalar);
            }
          }
          
          %circle(d = hole[1]);
        }
      }
      
      nextXOffset = reverse ?
        xOffset - minSpacing - 
          (hole[1] / 2) -
          ((holeIndex < len(row) - 1) ? row[holeIndex + 1][1] / 2 : 0)
      :
        xOffset + minSpacing + 
          (hole[1] / 2) +
          ((holeIndex < len(row) - 1) ? row[holeIndex + 1][1] / 2 : 0);
             
      screwDriverHoleSlicer(
        holes, 
        rowIndex,
        holeIndex + 1, 
        nextXOffset - ((holeIndex >= len(row) -1) ? minSpacing : 0), 
        yOffset, 
        minSpacing, 
        holeMax, 
        expand,
        reverse
      );
    } else {
      translate([0, yOffset + holeMax + minSpacing * 2, 0]) {
        screwDriverHoleSlicer(
          holes, 
          rowIndex + 1, 
          0, 
          xOffset - row[holeIndex - 1][1] / 2,
          yOffset + holeMax, 
          minSpacing, 
          0,
          expand,
          !reverse
        );
      }
    }
  }
}