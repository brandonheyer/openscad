include<./threads.scad>

CUBE_SIDE = 5;
CUBE_HEIGHT = 4;
BASE_HEIGHT = .75;
SCREW_HEIGHT = 4.5;
SCREW_SIZE = 4;
SCREW_PITCH = 1.5;


difference() {
  translate([0, 0, .5])
    difference() {      
      cube([CUBE_SIDE, CUBE_SIDE, CUBE_HEIGHT], center = true);

      translate([0, 2, 1])
        cube([CUBE_SIDE + 1, CUBE_SIDE + 1, CUBE_HEIGHT], center = true);  
    }
  
  translate([0, 0, -2.2])
    metric_thread(SCREW_SIZE + 0.4, SCREW_PITCH, SCREW_HEIGHT + 2.2, square = true, thread_size = SCREW_PITCH + 0.4);   
    
  translate([0, 0, -1.5])
    cylinder(SCREW_HEIGHT + 4, r = 1.5, $fn = 32);
}


*union() {
  translate([0, 0, -CUBE_HEIGHT / 2])
    metric_thread(SCREW_SIZE, SCREW_PITCH, SCREW_HEIGHT, square = true);

  translate([0, 0, -CUBE_HEIGHT / 2 - .25])
    cube([CUBE_SIDE, CUBE_SIDE, BASE_HEIGHT], center = true);
}