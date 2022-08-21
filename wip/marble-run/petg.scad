DIAMETER = 20.8;

previewMult = 0.375;
fnSixFour = downsample(128, 0.375 * .5);
fnThreeTwo = downsample(64, 0.375 * .5);


offsets = [0, [12.1, 24.2 - 4], 24.2];
rotates = [30, 90, 150];
includes2 = [
  [0, 0, 0, 1],
  [0, 1, 0, 0],
  [0, 0, 0, 1]
];

includes = [
  [0, 0, 0, 1],
  [0, 1, 0, 0],
  [0, 0, 0, 1]
];

function downsample(v = 64, previewMult = 0.375) = $preview ? v * previewMult : v;

module tubeSlicer(h = 100, d = DIAMETER, bottomThickness = 1, tz = 0) {
  translate([0, 0, d / 2 + bottomThickness + tz])
    union() {
      translate([0, 0, d / 2])
        cylinder(h, d = d, $fn = fnThreeTwo);
          
       translate([0, 0, d / 2])
        sphere(d = d, $fn = fnThreeTwo); 
    }
}

module tubeVase(h = 100, hull = true, bottomThickness = 1, tz = 0, tubeOffsets = false) {
  difference() {
    if (hull) {
      hull() {
        children();
      }
    } else {
      children();
    }
    
    to = is_list(tubeOffsets) ? tubeOffsets : is_num(tubeOffsets) ? [0, tubeOffsets] : [0];
    
    for (i = to) {
      x = is_list(i) ? i[0] : i;
      y = is_list(i) ? i[1] : 0;
      
      translate([x, y, 0])tubeSlicer(h, DIAMETER, bottomThickness, tz);
    }
  }
}

*tubeVase() {
  cube([DIAMETER * 1.4, DIAMETER * 1.4, 0.16], center = true);

  translate([0,0, 10]) 
    cylinder(h = 0.16, d = DIAMETER * 1.9, $fn = 8);
      
      rotate([0,0, 0]) 
        translate([0,0, 20]) 
          cylinder(h = 0.16, d = DIAMETER * 1.6, $fn = 6);
      
      translate([0, 0, 25]) cylinder(h = 0.16, d = DIAMETER * 1.3, $fn = 10);
} 

module spheroid(scalar = .45, cutTop = false, topZ = DIAMETER * 4.5) {
  scalarX = scalar[0] ? scalar[0] : scalar;
  scalarY = scalar[1] ? scalar[1] : scalar;
  
  scale([scalarX, scalarY, 1]) 
    difference() {
      sphere(d = DIAMETER * 5, $fn = fnSixFour);
      translate([0,0, DIAMETER * -2.5]) cube(DIAMETER * 5, center = true);
      
      if (cutTop) translate([0,0, topZ]) cube(DIAMETER * 5, center = true);
    }
}

module spheroidSlicers(offset = DIAMETER / .575, include = []) {
  if (include[3] != 0) translate([-offset, 0, -0.1]) spheroid();
  if (include[1] != 0) translate([offset, 0, -0.1]) spheroid();
  if (include[2] != 0) translate([0, -offset, -0.1]) spheroid();
  if (include[0] != 0) translate([0, offset, -0.1]) spheroid();
}
  
*tubeVase(120, false) {
  difference() {
    union() {
      spheroid([.4, .4], true);
      *rotate([0,0, 90]) spheroid([.6, .4], false);
      *cylinder(54, DIAMETER * 1.15, DIAMETER * .72, $fn = fnSixFour);
    }
    
    spheroidSlicers();
  }
}

*difference() { 
  union() { 
    spheroid();
  }
  translate([0, 0, DIAMETER * 2.25 + 8]) {
    rotate([0, 90, 0]) sphere(d = DIAMETER * 4.5, $fn = fnSixFour);
    translate([0, 0, -42]) cylinder(h = 20, d = DIAMETER * 9, $fn = 6);
  }
}

*tubeVase(120, false, tz = 20) {
  difference() {
    union() {
      spheroid([.6, .4], false);
      rotate([0,0, 90]) spheroid([.6, .4], false);
      cylinder(54, DIAMETER * 1.15, DIAMETER * .725, $fn = fnSixFour);
    }
    
    spheroidSlicers();
  }
}
 
spheroid();

*tubeVase(120, false, tz = 34) {
  offset = DIAMETER / .575;
  difference() {
    union() {
      difference() {
        union() {
          spheroid([1, .4], false);
          rotate([0,0, 90]) spheroid([1, .4], false);
        }
        
        translate([0,0,-5]) rotate([0,0, 90]) spheroid([.6, .6], false);
        rotate([0, 0, 45]) spheroidSlicers();
      }
      
      difference() {
        union() {
          cylinder(14, DIAMETER * 2.2, DIAMETER * .75, $fn = fnSixFour);  
          translate([0,0,14])
            cylinder(24, DIAMETER * .75, DIAMETER * 1.2, $fn = fnSixFour);
          
          translate([0, 0, 38])
            cylinder(30, DIAMETER * 1.2, DIAMETER * .725, $fn = fnSixFour);
        }
        
        rotate([0, 0, 45]) spheroidSlicers();
      }


    }
    
    spheroidSlicers(include = [0,0,0,0]);
  }
}

*tubeVase(120, false, tubeOffsets = offsets) {
  difference() {
    union() {
      for (i = [0 , 1, len(offsets) -1]) {
        x = is_list(offsets[i]) ? offsets[i][0] : offsets[i];
        y = is_list(offsets[i]) ? offsets[i][1] : 0;
        
        translate([x, y, 0]) rotate([0, 0, rotates[i]]) spheroid([.4, .4], true);
      }
     
      translate([12, 6, 40])
        scale([1, 1, 2]) sphere(20, $fn = fnSixFour);
    }
    
    for (i = [0, 1, len(offsets) - 1]) {
      o = offsets[i];
      x = is_list(o) ? o[0] : o;
      y = is_list(o) ? o[1] : 0;
      
      translate([x, y, 0]) rotate([0, 0, rotates[i]]) spheroidSlicers(include = includes[i]);
    }
  }
}

*tubeVase(120, false, tubeOffsets = offsets) {
  difference() {
    union() {
      for (i = [0 , 1, len(offsets) -1]) {
        x = is_list(offsets[i]) ? offsets[i][0] : offsets[i];
        y = is_list(offsets[i]) ? offsets[i][1] : 0;
        
        translate([x, y, 0]) rotate([0, 0, rotates[i]]) {
          spheroid([.4, .4], true);
        }
      }
    }
    
    for (i = [0, 1, len(offsets) - 1]) {
      o = offsets[i];
      x = is_list(o) ? o[0] : o;
      y = is_list(o) ? o[1] : 0;
      
      translate([x, y, 0]) rotate([0, 0, rotates[i]]) spheroidSlicers(include = includes[i]);
    }
  }
}