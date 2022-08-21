module cap(h, d) {
  difference() {
    rotate([0, 0, 22.5])
      cylinder(d = d, h = h, center = true, $fn = 8);

    translate([0, d * cos(22.5), 0])
      cube([5, d * 1.5, h + 2], center = true);
    
    translate([0, -d / 2, 0])
      cube([d * 1.5, d, h + 2], center = true);
   
    rotate([0, 0, 45])
      translate([sin(22.5) * (d) + (d / 4), 0, 0])
        cylinder(d = d / 2.2, h = h + 2, center = true, $fn = 64);
    
    rotate([0, 0, 135])
      translate([sin(22.5) * (d) + (d / 4), 0, 0])
        cylinder(d = d / 2.2, h = h + 2, center = true, $fn = 64);
  }
}

module tee(h, d, cut = 5) {
  difference() {
    scale([1, 1.33, 1])
      rotate([0, 0, 22.5])
        cylinder(d = d, h = h, center = true, $fn = 8);

    for (i = [0 : 180 : 0])
      rotate([0, 0, i])
        translate([0, d * cos(22.5) * 1.33 - d/2, 0])
          cube([5, d, h + 2], center = true);
      
    rotate([0, 0, 90])
      translate([d  / -2 + .51,  0, 0])
        cube([2 + d, d * 1.5, h + 2], center = true);

    rotate([0, 0, 0])
      translate([0, 0, cut / -2 - 1])
        cube([5, d * 1.5, h  + 2 - cut], center = true);

    rotate([0, 0, 90])
      translate([4, 0, cut / -2 - 1])
        cube([5, d * 1.5, h  + 2 - cut], center = true);

    for (i = [0 : 180 : 180])
      rotate([0, 0, i]) {
        rotate([0, 0, 45])
          translate([sin(22.5) * (d) + (d / 4), 0, 0])
            cylinder(d = d / 2.1, h = h + 2, center = true, $fn = 64);
        
        rotate([0, 0, 135])
          translate([sin(22.5) * (d) + (d / 4), 0, 0])
            cylinder(d = d / 2.1, h = h + 2, center = true, $fn = 64);
      }
  }
}

module corner(h, d, cut = 5) {
  difference() {
    scale([1, 1.33, 1])
      rotate([0, 0, 22.5])
        cylinder(d = d, h = h, center = true, $fn = 8);

    for (i = [0 : 180 : 0])
      rotate([0, 0, i])
        translate([0, d * cos(22.5) * 1.33 - d/2, 0])
          cube([5, d, h + 2], center = true);
      
    *rotate([0, 0, 90])
      translate([1.33 * -d / 2  * cos(22.5) + 5,  0, 0])
        cube([d, d * 1.5, h + 2], center = true);
    
    *rotate([0, 0, 180])
      translate([d  / -2 - 2.5 - 1 + 0.1,  0, 0])
        cube([2 + d, d * 1.5, h + 2], center = true);


    rotate([0, 0, 0])
      translate([0, 0, cut / -2 - 1])
        cube([5, d * 1.5, h  + 2 - cut], center = true);

    rotate([0, 0, 90])
      translate([4, 0, cut / -2 - 1])
        cube([5, d * 1.5, h  + 2 - cut], center = true);
 
    #for (i = [0 : 180 : 180])
      rotate([0, 0, i]) {
        rotate([0, 0, 45])
          translate([sin(22.5) * (d) + (d * 1.33 / 4), 0, 0])
            cylinder(d = d / 2.1, h = h + 2, center = true, $fn = 64);
        
        rotate([0, 0, 135])
          translate([sin(22.5) * (d) + (d / 4), 0, 0])
            cylinder(d = d / 2.1, h = h + 2, center = true, $fn = 64);
      }
  }
}

h = 35;
d = 30;

corner(h, d);            

*translate([0, 1, -h / 2])
  cube([255, 3, h]);

*for(i = [0 : 1 : 3])
  translate([(51 + (cos(22.5) * 7.5)) + i * 51, 1.5, 0])
    cap(h, 15);