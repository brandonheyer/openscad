module triangleSlicer(divider, rs, h, d, cutD) {
  slice = divider * 1.5;
  
  translate([-divider / 2 - 1, divider / 2 + 1, -1])
    linear_extrude(h + 2, convexity = 2)        
      polygon([
        [-slice, -slice], 
        [slice, slice],
        [slice, -slice],
      ]);
  
  cw = divider;
  
  for (rz= [0, 1])
    mirror([rz, rz, 0])
      translate([
        -divider * 2 + cw - 0.1, 
        -1.5, 
        (h) / 2
      ])
        cube([cw, cw, h + 2], center = true);
  
  for (zr = rs) {
    y = cos(22.5) * (cutD / 2 + d / 2);
    rotate([0, 0, zr + 45])
      translate([0, y, -1])
        cylinder(d = cutD * 1.01, h = h + 2, $fn = 128);
  }
}

module supports(h, d, sides = 4, divider = 5, backT = 2, backOnly = false) { 
  separation = divider + 0.4 * 6 * 2;
  cutD = (d - separation);
  $fn = 64;
  
  rs = (
    (sides == 4) ? 
      [0, 90, 180, 270] :
        (
          (sides == 2) ? 
            [0, 270] :
              [0]
        )
  );
  
  edgeH = 5;
  edgeW = 3; 
   
  if (!backOnly) {
    intersection() {
      difference() {
        union () {
          cutD = (d * 1.5 - separation);
          linear_extrude(h) 
            offset(r = 1) 
              offset(delta = -1) { 
                intersection() {
                  difference() {
                    square(d * 1.5, center = true);
                     
                    for (i = rs) {
                      y = cos(22.5) * (cutD / 2 + d * 1.5 / 2) - 3.4;
                      rotate([0, 0, i + 45])
                        translate([0, y, 0])
                          circle(d = cutD, $fn = 256);
                    }
                   
                    rotate([0, 0, 45]) 
                      translate([0, 2, 0])
                        square([d / 2, d / 2], center = true); 
                    
                    for (m = [0, 1]) {
                      mirror([m, m, 0])
                        rotate([0, 0, 180])
                          translate([(d * 1.5 /  2) - divider / 2, -1, 0])
                            square([divider * 2, divider - 0.8], center = true); 
                      }
                    }
                  
                  // needed to trim excess sides
                  for (i = rs) {
                    y = cos(22.5) * (cutD / 2 + d / 2);
                    rotate([0, 0, i + 45])
                      translate([0, y / 1.5, 0])
                        circle(d = cutD, $fn = 64);
                  }
                }
              }
        }
          
        for (zr = rs) {
          for (zs = [20])
            rotate([0, 0, zr])
              translate([0, 0, zs])   
                rotate([0, 90, 135])
                  translate([0, 0, -d / 2]) {
                    cylinder(d = 3.5, h = d);            
                    
                    translate([0, 0, d - 2.2])
                        cylinder(d = 6.8, h = 3, $fn = 6);
                  }
        }
      }

     rotate([90, 0, -45])
        translate([16, h / 2, 0]) {
          intersection(){
          cylinder(d = h + 16, h = d, center = true, $fn = 256);
      
        rotate([0, 15, 0])
          cylinder(d = h + 16, h = d * 2, center = true, $fn = 256);
      
      
        rotate([0, -15, 0])
          cylinder(d = h + 16, h = d * 2, center = true, $fn = 256);
          }
      }
    }
  }
  
  if (backOnly && (sides == 1 || sides == 0)) {
    *rotate([0, 0, -45]) translate([-17.8, -20, 0]) cube([10, 40, 10]);
    
    intersection() {
      difference() {
        off = 2.5;
        step = 0;
        $fn = 64;
        
        linear_extrude(h, convexity = 3)
          offset(r = .5) 
            offset(delta = -.5)
              polygon([
                [-divider + backT - 2.5 - 1.5, -off - backT + 3],
                [-d / 2 - divider / 2, -off - backT + 3],
                [-d / 2 - divider / 2 + 2, -off + 3],
                [-divider - off, -off + 3],
                [-divider - off, step + 3.75],
                [-divider - backT + 2.5, step + 3.75],
                
                [-step - 3.75, divider + backT - 2.5],
                [-step - 3.75, divider + off],
                [off - 3, divider + off],
                [off - 3, d / 2 + divider / 2 - 2],
                [off + backT - 3, d / 2 + divider / 2],
                [off + backT - 3, divider - backT + 2.5 + 1.5]
              ]);
      
        for (zr = rs) {
          for (zs = [20])
            rotate([0, 0, zr])
              translate([0, 0, zs])    
                rotate([0, 90, 135]) {
                  translate([0, 0, -d / 2])
                    cylinder(d = 3.75, h = d);
                }
              }
      
      }
      
      rotate([90, 0, -45])
        translate([14, h / 2, 0]) {
          intersection(){
          cylinder(d = h + 16, h = d, center = true, $fn = 256);
      
        rotate([0, 15, 0])
          cylinder(d = h + 16, h = d * 2, center = true, $fn = 256);
      
      
        rotate([0, -15, 0])
          cylinder(d = h + 16, h = d * 2, center = true, $fn = 256);
          }
      }
    }
  }
  
  if (backOnly && sides == 2) {
    intersection() {
      difference() {
        off = 2.5;
        step = 0;
        $fn = 64;
        
        union() {
          linear_extrude(h, convexity = 3)
            offset(r = 0.8) 
              offset(delta = -0.8)
                union()
                  for (zm = [0, 1])
                    mirror([zm, 0, 0])
                      translate([1, 0, 0])
                         polygon([
                          [-divider + backT - 4, -off - backT + 3],
                          [-d / 2 - divider / 2 + 1, -off - backT + 3],
                          [-d / 2 - divider / 2, -off + 3],
                          [-divider - off, -off + 3],
                          [-divider - off, step + 3.75 - .75],
                          
                          [-step - 3.5, divider - backT + 5],
                          [-step - 3.5, divider - backT + 5.4],
                          [off + backT - 3, divider  - backT + 5.4]
                     ]);
                  
        for (zr = rs) 
          mirror([zr, 0, 0]) {
            translate([0, -1.5, h - h / 3])
              cube([6.5, 4, h / 3]);
          
            translate([0, .5, h - h / 3])
              cube([3, 5, h / 3]);
            
            
            translate([0, -1.5, 0])
              cube([6.5, 4, h / 3]);
          
            translate([0, .5, 0])
              cube([3, 5, h / 3]);
          }
        }
                
        for (zr = rs) {
          for (zs = [20])
            mirror([zr, 0, 0])
              translate([0, 3, zs])    
                rotate([0, 90, 135]) {
                  translate([0, 0, 0])
                    cylinder(d = 3.7, h = d / 2);
                  }
              }
     
        for (zr = rs) 
          mirror([zr, 0, 0])
            translate([-0, 3, 20])
              rotate([0, 90, 45])
                translate([0, 0, -0.5])
                  cylinder(d = 9, h = 4.6, $fn = 6);
  
  }
    
      rotate([90, 0, -90])
        translate([8.5, h / 2, 0]) {
          intersection(){
            cylinder(d = h + 5, h = d * 1.5, center = true, $fn = 256);
      
            rotate([0, 20, 0])
              cylinder(d = h + 5, h = d * 2 * 1.5, center = true, $fn = 256);
          
          
            rotate([0, -20, 0])
              cylinder(d = h + 5, h = d * 2 * 1.5, center = true, $fn = 256);
          }
      }  
    }
  }
}

*translate([30, 0, 0])
  supports(40, 20, sides = 4);


group() {
  %group() {
    translate([0 + 6.25 + .25, .5, 0])
      cube([5, 5, 40]);
    
    translate([0 - 6.25 - 5.25, .5, 0])
      cube([5, 5, 40]);

    translate([0 - 2.5, 4.75 + 1.25, 0])
      cube([5, 5, 40]);
  }

  translate([0, 0, 0]) {
    translate([0.6, 2.4, 0])
      supports(40, 20, sides = 1, backOnly = false);
   
    translate([-0.6, 2.4, 0])
      rotate([0, 0, -90])
        supports(40, 20, sides = 1, backOnly = false);
  }

 !  supports(40, 20, sides = 2, backOnly = true);
}

translate([25, 0, 0]) {
  %group("green") {
    translate([0 - 6.5 - 6, 0.5, 0])
      cube([5, 5, 40]);

    translate([0 - 5.5, 6.25 + 1.25, 0])
      cube([5, 5, 40]);
  }

  translate([-2.4, 2.4, 0])
  supports(40, 20, sides = 1, backOnly = false);
  
  supports(40, 20, sides = 1, backOnly = true);
}