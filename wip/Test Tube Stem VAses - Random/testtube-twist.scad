h = 120;
ttd = 20.8;

*group() {
  difference() {
    translate([0, 0, h / 2])
      linear_extrude(h, center = true, twist = 540, scale = 0.55, $fn = 64) {
        translate([10, 5, 0]) circle(r = 5, $fn = 32);
        translate([10, -0, 0]) circle(r = 8, $fn = 32);
        translate([10, -5, 0]) circle(r = 5, $fn = 32);
      }
    
    translate([0, 0, -1]) cylinder(h = h + 2, d = ttd, $fn = 64);
  }

  difference() {
    cylinder(11, 15.5, 10.5, $fn = 32);
    
    translate([0, 0, 11.4]) 
      sphere(d = ttd);
  }
}

difference() {
  cylinder(h, ttd / 2 + 6, ttd / 2 + 2);
  translate([0,0, 1]) cylinder(h, d = ttd);
  
  for (i = [2 : 1 : 10]) {
    translate([0, 0, i * 12]) {
      rotate([0, 0, i * 40]) {
        translate([-ttd, 0, 1])
          rotate([0, 90, 0]) cylinder(ttd * 2, 6, 6, $fn = 6);
      }
        
      rotate([0, 0, 60 + i * 40]) {
        translate([-ttd, 0, 0])
          rotate([0, 90, 0]) cylinder(ttd * 2, 7, 7, $fn = 6);
      }
      
      rotate([0, 0, 120 + i * 40]) {
        translate([-ttd, 0, 0])
          rotate([0, 90, 0]) cylinder(ttd * 2, 5, 5, $fn = 6);
      }
    }
  }
}