*difference() {
  cube([6 + (3 * sqrt(2)), 9.75, 3], center = true);
  
  translate([-5, 0, 0])
    rotate([0, 45, 0])
      cube([3, 12, 3], center = true);

  translate([5, 0, 0])
    rotate([0, 45, 0])
      cube([3, 12, 3], center = true);
}

*difference() {
  union() {
    translate([0, 0, -2.24])
      cube([12, 10, 1], center = true);
    
    translate([-5.32, 0, 0])
      rotate([0, 45, 0])
        cube([3, 10, 3], center = true);

    translate([5.32, 0, 0])
      rotate([0, 45, 0])
        cube([3, 10, 3], center = true);
    
    
    translate([0, 5.25, 0])
      cube([10.6, .5, 5.4], center = true);
  }
 
  translate([-7.3, 0, 0])
    cube([4, 11, 10], center = true);
  
  translate([7.3, 0, 0])
    cube([4, 11, 10], center = true);
  
  translate([0, 0, 3])
    cube([14, 12, 3], center = true);
}


module slideShape(width, length, height, diameter, center = false) {
  txa = center ? width / -2 : width;
  tya = center ? 0 : height / 2;
  
  txb = center ? width / 2 : 0;
  tyb = center ? 0 : height / 2;
  
  sideLength = sqrt((diameter * diameter) - (height * height));
  sideShift = (sideLength * sqrt(2) / 2) + (sideLength / 2);
  
  square([width - (sideShift * 2), height], center = center);
      
  translate([txa + sideShift, tya, 0])
    rotate([0, 0, 22.5])
      circle(d = diameter, $fn = 8);

  translate([txb - sideShift, tyb, 0])
    rotate([0, 0, 22.5])
      circle(d = diameter, $fn = 8); 
}

module slide(size, center = false, slices = 1, outer = false) {
  width = size[0];
  length = size[1];
  height = size[2];
  diameter = height / sin(67.5);
  offset = outer ? 0.4 : 0;
  
  rotate([90, 0, 0])
    linear_extrude(length, center = center, slices = slices) {
      offset(offset)
        slideShape(width, length, height, diameter, center);
    }
}


slide([15, 10, 8], center = true);

difference() {
    slide([18.3, 10, 11.3], center = true);
    slide([15, 12, 8], center = true, outer = true);
  

}
