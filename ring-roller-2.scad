include <./bearings.scad>;
include <../marble-run/library.scad>;

module semiCylinder(h) {
  rotate([0, 90, 0])
      difference() {
        cylinder(h, 2, 2, $fn = 16);
          translate([2.5, 0, h / 2])
            cube([5, 5, h + 2], center = true);
      }
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


CUBE_SIDE = 9.5;
CUBE_HEIGHT = 8;
BASE_HEIGHT = 2;
SCREW_HEIGHT = 9;
SCREW_SIZE = 4;
SCREW_PITCH = 1.5;
AIR_GAP = 0.4;
EXTRA_HEIGHT = 5;

*group() {
  union() {
    bearing(11, 3, 2, 1, extraHeight = 0); 

    difference() {
      union() {
        cylinder(2.5, 12, 14);
        cylinder(1, 12.5, 12, center = true, $fn = 16);
        
        mirror([0, 0, 1])
          rotate([0, 0, 11.25])
            cylinder(1, 12.5, 12, center = true, $fn = 16);
        
        translate([0, 0, -2.5])
          cylinder(2.5, 14, 12);
      }
      
      cylinder(7, 10, 10, center = true);
    }
  }

  // GRIP HANDLE
  translate([11, 0, 2.5]) {
    cylinder(3, 2.75, 2.5, $fn = 16);

    translate([0, 0, 3])
      cylinder(4, 2.5, 2.5, $fn = 16);
  }


  // Axel Supports
  translate([0, 0, -1]) {
    
    // Base Bottom
    translate([0, 0, -3]) {
      cylinder(1.85, 8, 7, $fn = 9);
    }

    // Main Axel
    translate([0, 0, 1])
      cylinder(5, 4, 4, center = true);
  }


  // Tension Bearing
  translate([-21.25, 0, 0]) {
    bearing(7.25, 1.7, 1.5, 0.5, .66, .66, extraHeight = 0);
  }
    
  // Tension Supports
  translate([-21.25, 0, -1]) {
    cylinder(4, 2.1, 2.1, $fn = 16, center = true);
      
    translate([0, 0, -1.5]) {
      difference() {
        cylinder(1.5, 6, 4.5, center = true, $fn = 8);
        translate([0, 0, .3])
          cylinder(.46, 4.3, 4.3, $fn = 64);
      }
      
      translate([0, 0, .3])
        cylinder(.46, 2.925, 2.925, $fn = 64);
    }
    
    translate([0,0, -2.25])
      cylinder(.5, 6, 6, center = true, $fn = 8);
  } 
}

// WIRE
*translate([-13, 0, 0])
  rotate([90, 0, 0])
    cylinder(20, 1, 1, $fn = 32);

rotate([0, 90, 0])
  translate([6, 0, -30.5])
    screw(6, 3, 40.5 - (DIFFERENCE * 2), test = false);
 
difference() {
  translate([-20, 0, -6])
    rotate([0, 0, 90]) 
      slide([WIDTH, LENGTH / 1.9, HEIGHT], center = true);

*  translate([0, 0, -6]) {
    translate([4, 0, 0]) semiCylinder(6);
    translate([-8, 0, 0]) semiCylinder(8);
    translate([-20, 0, 0]) semiCylinder(8);
    translate([-32, 0, 0]) semiCylinder(8);
  }
     
  translate([-30, 0, -6])  
    rotate([0, 90, 0])
      cylinder(40, 1.9, 1.9, $fn = 32);

  rotate([0, 90, 0])
    translate([6, 0, -33.9])
      screw(6.4, 3, 40, internal = true, test = false);
}

*difference() {
  translate([-11 - DIFFERENCE, 0, -6])
    rotate([0, 0, 90]) 
      slide([WIDTH + 4, SLIDE_SIZE, HEIGHT + 2], center = true, outer = true);

  translate([-35, 0, -6])  
    rotate([0, 90, 0])
      cylinder(25, 2.125, 2.125, $fn = 16);

  translate([-7 - (DIFFERENCE), 0, -6])
    rotate([0, 0, 90]) 
      slide([WIDTH, 48 - DIFFERENCE - DIFFERENCE, HEIGHT], center = true, outer = true);
  
  translate([-10, 0, -1.5])
    cube([LENGTH * 2, WIDTH * 2, 2], center = true);
  
  translate([-10, 0, -11.75])
    cube([LENGTH * 2, WIDTH * 2, 4], center = true);
}

translate([-35, 0, -6])  
  rotate([0, 90, 0])
    cylinder(4.5, 2, 2, $fn = 32);

// NUT HEAD
translate([-37, 0, -6])  
  rotate([0, 90, 0])
    rotate([0, 0, 90])
      cylinder(2, 4.125, 4.125, $fn = 6);

translate([10 - DIFFERENCE * 2, 0, -6])  
  rotate([0, 90, 0])
    cylinder(1, 1.2, 1.2, $fn = 32);

*translate([11.2 - DIFFERENCE * 2, 0, -6])
  difference() {
    rotate([0, 0, 90]) 
      slide([WIDTH, 1.6, HEIGHT], center = true, outer = true);
    
    translate([-1, 0, 0])
      rotate([0, 90, 0])
        cylinder(1.4, 1.5, 1.5, $fn = 32);
      
    translate([-20, 0, 5.5])
      cube([LENGTH * 2, WIDTH * 2, 4], center = true);
    
    translate([-20, 0, -5.75])
      cube([LENGTH * 2, WIDTH * 2, 4], center = true);
  }
  
  
OG_SLIDE_SIZE = 46;
SLIDE_SIZE = 26;
DIFFERENCE = (OG_SLIDE_SIZE - SLIDE_SIZE) / 2;
HEIGHT = 8;
LENGTH = 38;
WIDTH = 10;