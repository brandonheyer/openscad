$fn = 32;  
h = 8;
w = 5;

for(i = [0 : 1 : 2]) {
  translate([0, i * w, 0])
    difference() {
      translate([0, 0, -2])
        cube([19, w, h + 2 - 0.1]);

        translate([w / 2, w / 2, 0]) {
          translate([0, 0, 0])
            cylinder(h, d = 2.5);
          
          translate([4, 0, 0])
            cylinder(h, d = 2.7);
          
          translate([8.5, 0, 0])
            cylinder(h, d = 3);
          
          translate([13.5, 0, 0])
            cylinder(h, d = 3.1);
        }
    }
}