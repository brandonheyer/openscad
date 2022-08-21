R1 = 40;
SCALE = 0.25;
HSCALE = 0.8;
R2 = R1 * SCALE;
H = 80;

echo(R2);

module section(r) {
  circle(r = r, $fn = 3);

  rotate([0, 0, 60]) 
    circle(r = r, $fn = 3);
}

module axel(r) {
  circle(r = r, $fn = 3);

  rotate([0, 0, 60]) 
    circle(r = r, $fn = 3);
}

difference() {
  union() {
    r1 = R1 * HSCALE;
    
    linear_extrude(r1 + 6, twist = 90, scale = 0.1, slices = 8)
      section(R1);

    translate([0, 0, 5]) rotate([0, 0, 30])
      linear_extrude(H + r1, twist = 0, slices = 16) 
        axel(R2);

    translate([0, 0, r1 * 2 + H])
      rotate([180, 0, 0])
        linear_extrude(r1 + 6, twist = 90, scale = 0.1, slices = 8)
          section(R1);
  } 

  for (i = [0 : 1 : 2])
    rotate([0, 0, i * 120])
      translate([-0.05, 0.45, -0.5]) {
        cube([0.1, R1, R1 + H + R1 + 1]);
      }
      
      
  for (i = [0 : 1 : 2])
    rotate([0, 0, 30 + i * 120])
      translate([-1.4, R1 * .61, -0.5]) {
        cube([2.8, R1 * .4, R1 + H + R1 + 1]);
      }
      
}

*intersection() {
  union() {
    r1 = R1 * HSCALE;
    
    linear_extrude(r1, twist = 0, scale = SCALE, slices = 10)
      section(R1);

    translate([0, 0, r1])
      linear_extrude(H, twist = 0, slices = 18) 
        section(R2);

    translate([0, 0, r1 * 2 + H])
      rotate([180, 0, 0])
        linear_extrude(r1, twist = 0, scale = SCALE, slices = 10)
          section(R1);
  } 

  for (i = [0 : 1 : 7])
    rotate([0, 0, i * 45])
      translate([-0.45, 0, -0.5]) {
        cube([0.9, R1 * 1.01, R1 + H + R1 + 1]);
      }
      
      

      
}

*difference() {
  cylinder(h = R1 * HSCALE * 2 + H, r = R2 * 0.8, $fn = 8);
  
  *translate([0, 0, -0.5]) cylinder(h = R1 * HSCALE * 2 + H + 1, r = R2 - 0.1, $fn = 8);
}