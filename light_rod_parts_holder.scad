
module rodHolder() {
  translate([0, 0, 0]) linear_extrude(6)
    difference() {
      circle(d=20, $fn = 64);
      circle(d=15.5, $fn = 64);
      offset(0.1) {
        difference() {
          circle(d = 17, $fn = 12);
          circle(d = 13.8, $fn = 12);
          rotate([0, 0, 93]) square([20, 8], center = true);
          rotate([0, 0, 87]) square([20, 8], center = true);
        }
        
        translate([-8, -1.2, 0]) square([16, 2.4]);
      }
    }
}

module baseHolder() {
  difference() {
  translate([0, -10, 0])
    difference() {
      cube([8.1, 20.125, 6]);
      translate([1.2, -.5, -1]) cube([5.5, 5.1, 12]);
      translate([.75, .8, -1]) cube([6.6, 4.1, 12]);
    }
    
    *translate([ 0,0,-1]) linear_extrude(20) translate([9.7, 21, 0]) circle(d=20, $fn = 64);
  }
}

*for (i = [0 : 1 : 2]) 
  translate([i * 18, 0, 0]) rotate([0, 0, 90]) rodHolder();


x1 = 0;
x2 = 8.1 + 40;
x3 = x2 + 8.1 + 40;

translate([0, 0, 0]) {
  translate([x1, -20.75, 0]) baseHolder();
  translate([x2, -20.75, 0]) baseHolder();
  translate([x3, -20.75, 0]) baseHolder();
}

linear_extrude(6)
translate([8.5, -2.9, 0])
difference() {
  union() {
    for (i = [0 : 1 : 5]) 
      translate([i * 17.5, 0, 0]) rotate([0, 0, 90]) circle(d=24);
  }

  for (i = [0 : 1 : 5])  {
    translate([i * 17.5, 7, 0]) rotate([0, 0, 30]) circle(d = 26, $fn = 3);
    translate([i * 17.5, 0, 0]) rotate([0, 0, 90]) circle(d=13);
  }
}