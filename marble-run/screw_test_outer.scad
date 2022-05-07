include<./threads.scad>

CUBE_SIDE = 9.5;
CUBE_HEIGHT = 8;
BASE_HEIGHT = 2;
SCREW_HEIGHT = 9;
SCREW_SIZE = 6;
SCREW_PITCH = 4;
AIR_GAP = 0.4;
EXTRA_HEIGHT = 5;

module screw(
  diameter,
  pitch,
  height,
  thread_size,
  airGap = AIR_GAP,
  internal = false,
  diameterScale = 3.25
) {
  d = diameter + airGap;
  ts = internal ? pitch + (airGap * 2) : pitch;
  
  if (internal) {
#    cylinder(height, r = d / diameterScale, $fn = 128);
  }
  
  metric_thread(
    d,
    pitch,
    height,
    square = true,
    internal = internal,
    thread_size = ts
  );
}
  

difference() {
  difference() {  
    translate([0, 0, -1])    
      cube([CUBE_SIDE, CUBE_SIDE, CUBE_HEIGHT + 2], center = true);

    translate([0, CUBE_SIDE / 2, CUBE_SIDE / 4 + 1])
      cube([CUBE_SIDE + 1, CUBE_SIDE, CUBE_HEIGHT], center = true);  
  }
  
    translate([0, 0, - (CUBE_HEIGHT / 2) - 2]) {
      screw(
        SCREW_SIZE + AIR_GAP, 
        SCREW_PITCH, 
        SCREW_HEIGHT + EXTRA_HEIGHT, 
        internal = true,
        airGap = AIR_GAP
      );
    }
}


translate([0, 0, SCREW_PITCH + AIR_GAP])
group() {
  translate([0, 0, -(CUBE_HEIGHT / 2) - 6])
    screw(SCREW_SIZE, SCREW_PITCH, SCREW_HEIGHT + 6);

  translate([0, 0, -CUBE_HEIGHT / 2 - (BASE_HEIGHT / 2) - 1 - 4])
    cylinder(BASE_HEIGHT, d = CUBE_SIDE, center = true, $fn = 6);
}