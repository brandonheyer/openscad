include <./library.scad>
include <./constants.scad>

topSupportOffsetZ = SUPPORT_HEIGHT + AIR_GAP + ROLLER_HEIGHT + AIR_GAP;

airGap = AIR_GAP;
supportSize = GUIDE_RADIUS * 2;
baseWidth = supportSize * sqrt(3);
supportHeight = SUPPORT_HEIGHT + 1;
offsetZ = supportHeight + airGap + airGap + ROLLER_HEIGHT;
sideLength = 20;


translate([0, .25, 0])
driveRoller(
  ROLLER_OUTER_RADIUS + 1,
  airGap,
  WIRE_RADIUS, 
  DEFAULT_RIM_HEIGHT, 
  supportHeight,
  gripperRotationOffset = 20,
  $fn = 16
);

translate([0, 0, 2]) {
  
  difference() {
    cylinder(
      offsetZ + supportHeight,
      r= ROLLER_OUTER_RADIUS,
      center = true
    );
    
  translate([0, ROLLER_OUTER_RADIUS * 1.69, 0])
    cube([ROLLER_OUTER_RADIUS * 2 + 8, ROLLER_OUTER_RADIUS * 2, 10], center = true);

  translate([0, 0, -1])
    cylinder(
      offsetZ + supportHeight + 3,
      r= ROLLER_OUTER_RADIUS - 2,
      center = true
    );
  }
}
  


xOffset = sideLength / 2 + 2;
yOffset = xOffset * sqrt(3) - 6.5;

translate([0, yOffset - 2.5, 0]) {
  translate([xOffset, 0, 0])
    guideRoller(GUIDE_RADIUS - .5, 4, airGap, supportHeight); 
  
  translate([-xOffset, 0, 0])
    guideRoller(GUIDE_RADIUS - .5, 4, airGap, supportHeight); 
}



difference() {
  translate([0, 7.5, -airGap])
    rollerFrame(20, airGap, 4, 20, supportHeight);

  translate([20.5, 8, 2])
    cube([14, 30, 15], center = true);
  
  translate([-20.5, 8, 2])
    cube([14, 30, 15], center = true);
  
  translate([0, 22, 2])
    rotate([0, 0, 45])
      cube([16, 16, 15], center = true);
}

translate([0, 12, -2.5])
  cylinder(9, 2, 2, $fn = 64);