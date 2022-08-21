import("./originals/lily58-top.stl");


color("blue")
  translate([62.4, 3.201, -66]) {
    translate([0, 0, .8]) cube([2,6,2]);
    translate([2, 0, 6.2] ) rotate([0, 60, 0]) cube([2,6,2.2]);
    translate([-1, 0, 4.5]) rotate([0, -60, 0]) cube([2,6,2.4]);
}


color("blue")
  translate([86.9, 3.201, -76.5]) {
    cube([2,6,2]);
    translate([0, 0, -5.9]) cube([2,6,2]);
    
    translate([-1, 0, -2.9]) rotate([0, -90, 0]) cube([2,6,2]);
    
    translate([3, 0, -2]) rotate([0, 120, 0]) cube([2,6,2]);
  }
  
  
color("blue")
  translate([86.9, 3.201, -114.6]) {
    translate([.99, 5, -1.844]) rotate([90, 0, 0])
      cylinder(d = 2.8, h = 5, $fn = 32);
    
    cube([2,6,2]);
    translate([0, 0, -5.9]) cube([2,6,2]);
    
    translate([-1, 0, -2.9]) rotate([0, -90, 0]) cube([2,6,2]);
    
    translate([3, 0, -2]) rotate([0, 120, 0]) cube([2,6,2]);
  }
      
color("blue")
  translate([163, 3.201, -112.25]) {
    cube([2,6,2]);
    translate([0, 0, -5.8]) cube([2,6,2]);
    
    translate([-1, 0, -2.9]) rotate([0, -90, 0]) cube([2,6,2]);
    
    
    translate([2.2, 0, -0.4]) rotate([0, 60, 0]) cube([2,6,2]);
  }
  
      
color("blue")
  translate([163, 3.201, -74.25]) {
    cube([2,6,2]);
    translate([0, 0, -5.8]) cube([2,6,2]);
    
    translate([-1, 0, -2.9]) rotate([0, -90, 0]) cube([2,6,2]);
    
    translate([2.2, 0, -0.4]) rotate([0, 60, 0]) cube([2,6,2]);
  }
  
  
  
  
