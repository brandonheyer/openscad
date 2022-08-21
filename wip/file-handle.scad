difference() {
  cylinder(50, 7.5, 7.5, $fn = 32);
  
  translate([0, 0, 5])
    cylinder(50, 1.3, 1.3, $fn = 8);
  
  for (i = [0 : 1 : 8]) {
  *  rotate([0, -2.5, i * 45])
      translate([9, 0, 30]) {
          cylinder(20, 3, 4.5, $fn = 16);
      }
      
   *  rotate([0, 0, i * 45])
      translate([8, 0, -2.5]) {
          cylinder(55, 2, 3.5, $fn = 8);
      }   
  }
  
  translate([0, 0, 35])
  cube([40, 40, 50], center = true);
}