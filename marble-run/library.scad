include <./constants.scad>;
include<./threads.scad>

EXTRUSION_SIZE = 0.4;

module tube(inner, outer, h = DEFAULT_HEIGHT, $fn = 32) {
  in = min(outer, inner);
  out = max(outer, inner);

  difference() {
    cylinder(h, out, out, $fn);
    translate([0, 0, -1]) 
      cylinder(h + 2, in, in,  $fn);
  };
}

module rtCylinder(radius, posX, rotate, isTrim = false, h = DEFAULT_HEIGHT, $fn = 32, $posY = 0, $innerRotation = 0) {    
    rotate(rotate) {
        if (isTrim) {            
            translate([posX, $posY, -1])
                rotate($innerRotation)
                    cylinder(h + 2, radius, radius, $fn = $fn);
        } else {
            translate([posX, $posY, 0])
                rotate($innerRotation)
                    cylinder(h, radius, radius, $fn = $fn);
        }        
    }; 
}

module rtCube(width, length, posX, rotate, isTrim = false, h = DEFAULT_HEIGHT, $center = false, $posY = 0) {
    translateZ = $center ? h / 2 : isTrim ? -1 : 0;
    height = isTrim ? h + 2 : h;
    
    rotate(rotate)
        translate([posX, $posY, translateZ])
            cube([width, length, height], center = $center);
}


module base(width = BASE_WIDTH, h = DEFAULT_HEIGHT, riser = true, rotation = 90) {
    translate([-width / 2, 1, 0])
        rotate([rotation, 0, 0]) {
            if (riser) {
                translate([0, 1, 0])
                    rtCube(width, (WIRE_DIAMETER * .8) - 1, 0, 0, h = h + 1);
            }
            
            rtCube(width, 1, 0, 0, h = h + 1);
            translate([0, -1, 1.5])
                rtCube(width, 1, 0, 0, h = h - .5 );
            translate([0, -2, 0])
                rtCube(width, 1, 0, 0, h = h + 1);
        }
}

module supports(width, height) {
    translate([-width / 2, -width - (width / 2), 0])
        cube([width, width * .5, height]);
                    
    translate([-width / 2, width, 0])
        cube([width, width * .5, height]);
}

module sleeve(width, height, baseHeight, quad = true, supports = true, $fn = 8) {
    outerDiameter = width;
    cutWidth = WIRE_RADIUS;
    cutLength = WIRE_DIAMETER + width * .4; 
    
    difference() {
        union() {
            if (supports) {
              supports(width, height);
              
              if (quad) {
                  rotate([0, 0, 90]) supports(width, height);
              }    
            }
            
            tube(outerDiameter, WIRE_RADIUS * .5, height, $fn = 32);
        }
        
        translate([cutWidth / -2, cutLength / -2, .25])
            cube([cutWidth, cutLength, height]);
      
        if (quad) {    
            rotate([0, 0, 90])
                translate([cutWidth / -2, cutLength / -2, .25])
                    cube([cutWidth, cutLength, height]);
        }
    }
}

module baseSleeve(baseRadius = BASE_RADIUS, sleeveRadius = SLEEVE_RADIUS, h = 5, supports = true) {
  if (baseRadius) {
    translate([0, 0, -1])
      cylinder(1, baseRadius * 1.1, baseRadius * 1.1, $fn = 8);
  }    
  
  sleeve(sleeveRadius, h, sleeveRadius, true, supports, $fn);
}

module plugs(spacing = 10, xSleeves = 4, ySleeves = 2, useBase = true, useCrossbars = true, useSupports = true) {
  for(x = [1 : spacing : xSleeves * spacing]) {
    for (y = [1 : spacing : ySleeves * spacing]) {
      translate([x, y, 0]) {
        if ($children == 1) {
          children();
        } else {  
          if ($preview) {
            %color("#cc22cc")
              cylinder(5, WIRE_DIAMETER * 1.25, WIRE_DIAMETER * 1.25);
          } else {
            if (useBase) {
              baseSleeve(BASE_RADIUS, SLEEVE_RADIUS, useSupports);
            } else {
              baseSleeve(0, SLEEVE_RADIUS, useSupports);
            }
            
            if (useCrossbars) {
              if (x < (xSleeves - 1) * spacing) {
                translate([(SLEEVE_RADIUS - BASE_RADIUS), -.5, -1])
                  cube([spacing - (SLEEVE_RADIUS - BASE_RADIUS) * 2, 1, 3]);
              }
              
              if (y < (ySleeves - 1) * spacing) {
                rotate([0, 0, 90])                
                  translate([(SLEEVE_RADIUS - BASE_RADIUS), -.5, -1])
                    cube([spacing - (SLEEVE_RADIUS - BASE_RADIUS) * 2, 1, 3]);
              }
            }
          }
        }
      }
    }
  }
}

module nutHolder(h = 7, slicer = false, thickness = 2) {
  if (slicer) {
    translate([0, 0, -1])
      cylinder(h + 2, NUT_RADIUS, NUT_RADIUS, $fn = 6);
  } else {
    difference() {
      cylinder(h, NUT_RADIUS + thickness, NUT_RADIUS + thickness, $fn = 6);
      
      translate([0, 0, -1])
        cylinder(h + 2, NUT_RADIUS, NUT_RADIUS, $fn = 6);
    }
  }
}

module compassHolder(h = 5, slicer = false, thickness = 2, $fn = 64) {
  if (slicer) {
    translate([0, 0, -1])
      cylinder(h + 2, 5.1, 5.1, $fn = $fn);
  } else {
    difference() {
      cylinder(h, 5.1 + thickness, 5.1 + thickness);
        translate([0, 0, .5])
          cylinder(h, 5.1, 5.1, $fn = $fn);
    }
  }
}

module boltHeadSlicer(h = 5, $fn = 32) {
  translate([0, 0, -1])
    cylinder(h + 2, BOLT_HEAD_RADIUS, BOLT_HEAD_RADIUS, $fn = $fn);
}


module screwHole() {           
  scale([1.05, 1.05, 1]) {
    if ($preview) {
      cylinder(10, 3, 3);
    } else {
      translate([0, 0, 2.5])
        metric_thread(6.05, 1,  6.6);   
    }
  }
}

module slice(offset = 0.1) {
  translate([0, 0, -offset])
    children();
}

module wireSegment(h, wireRadius, radii, holderWidth = EXTRUSION_SIZE * 6) {
  outerRadius = wireRadius + holderWidth;
  r1 = wireRadius * (radii[0] ? radii[0] : 1);
  r2 = wireRadius * (radii[1] ? radii[1] : .9);
  
  difference() {
    cylinder(h, outerRadius, outerRadius, $fn = 16);
    slice() cylinder(h + 0.2, r1, r2, $fn = 16);
  }
}

module wireHolder(
  rotate = -135, 
  width = 1, 
  h = DEFAULT_HEIGHT, 
  wireRadius = WIRE_RADIUS, 
  marbleRadius = MARBLE_RADIUS,
  slicer = false,
  twoDee = false,
  projection = false,
  taper = true,
  holderWidth = EXTRUSION_SIZE * 6,
  test = $preview,
  $fn = 64
) {
  wr = wireRadius;
    
  difference() {
    rotate([0, 0, rotate]) 
      translate([marbleRadius + wr, 0, 0]) {     
        if (twoDee) {
          if (projection) {
            rotate([0, 0, 45]) square(wr * 2, center = true);
          } else {
            circle(wr, $fn = $fn);
          }
        }
        else if (slicer) {
          cylinder(h, wr, wr, $fn = $fn);
        } else {
          outerRadius = wr + holderWidth;
          cutSide = outerRadius;
          r1 = 10;
          r2 = 35;
          
          difference() {   
            if (taper) {
              union() {
                wireSegment(h / 5, wr, [1.1, 0.95], holderWidth);

                translate([0, 0,  h / 5])
                  wireSegment(3 * h /5, wr, [0.95, 0.95], holderWidth);
                
                translate([0, 0, 4 * h / 5])
                  wireSegment(h / 5, wr, [0.95, 1.1], holderWidth);
              }
            } else {
              wireSegment(h, wr, [1, 1], holderWidth);
            }
               
            rotate([0, 0, 180 - r1]) 
              translate([.7, -.5,  -0.1]) 
                cube([outerRadius, outerRadius * 2, h + 0.2]);           
           
            rotate([0, 0, 270 + r2]) 
              translate([outerRadius * -0.2, -2 * outerRadius,  -0.1]) mirror([1, 0, 0])
                cube([outerRadius * .9, outerRadius * 2, h + 0.2]);      
       
            rotate([0, 0, -45])
              translate([-1.825, -1.5 * outerRadius, -0.1]) 
                cube([outerRadius + 2, outerRadius, h + 0.2]);           
          } 
                          
          if (test) {
            %cylinder(h, wr, wr, $fn = 64);
          }
         }
      }        
    }
}

module bracket(
  h = DEFAULT_HEIGHT,
  holderHeight = 2,
  ring = false,
  wireRadius = WIRE_RADIUS,
  test = $preview
) {
    holderOffset = ((MARBLE_RADIUS + wireRadius) * sqrt(2) / 2) + wireRadius;
    trueCenter = holderOffset + DEFAULT_HEIGHT * .9;
    r1 = MARBLE_RADIUS + EXTRUSION_SIZE * 14;
    innerMult = 0.7;
  
    translate([0, 0, trueCenter]) {
      rotate([90, 0, 0])  {
        difference() {
          union() {
            difference() {          
              union() {  
                difference() {                
                  if (ring) {
                    cylinder(
                      h, 
                      r1, 
                      r1,
                      $fn = 128
                    );              
                  } else {
                    intersection() {
                      union() {
                        cylinder(
                          h, 
                          r1, 
                          r1,
                          $fn = 128
                        );
                        
                        for (i = [1, 0]) {
                          mirror([0, 0, i - 1])
                            translate([0, 0, i * h])
                              difference() {
                                cylinder(
                                  h / 2, 
                                  r1, 
                                  r1 * .92,
                                  $fn = 128
                                );              
                                
                                
                                translate([0,0,-0.1])
                                  cylinder(
                                    h + 0.2, 
                                    r1 * innerMult, 
                                    r1 * innerMult,
                                    $fn = 128
                                  );

                            }
                        }
                      }                  
                      
                      translate([0,  -r1 + .25, -h / 2 - 0.1])
                        cylinder(
                          h * 2 + 0.2,
                          r1,
                          r1 
                        );
                      }
                  }
                  
                  if (ring) {
                    translate([0,0,-0.1])
                      cylinder(
                        h + 0.2, 
                        r1 * innerMult, 
                        r1 * innerMult,
                        $fn = 128
                      ); 
                  } else {
                    translate([0, 0, -h / 2 -0.1])
                      cylinder(
                        h * 2 + 0.2, 
                        r1 * innerMult, 
                        r1 * innerMult,
                        $fn = 64
                      ); 
                  }
                }
              }
            
             translate([0, 0, -0.1])
               cylinder(
                 h + 0.2, 
                 MARBLE_RADIUS + EXTRUSION_SIZE * 1.3, 
                 MARBLE_RADIUS + EXTRUSION_SIZE * 1.3,
                 $fn = 64
               );            
             
            }
            
            if (ring) {
              for (i = [1, 0]) {
                mirror([0, 0, i - 1])
                  translate([0, 0, i * h])
                    difference() {
                      cylinder(
                        h / 2, 
                        r1, 
                        r1 * .92,
                        $fn = 128
                      );              
                      
                      
                      translate([0,0,-0.1])
                        cylinder(
                          h + 0.2, 
                          r1 * innerMult, 
                          r1 * innerMult,
                          $fn = 128
                        );

                  }
              }
            }
           
          
            translate([0, 0, -h / 2]) {
              wireHolder(h = h * 2, wireRadius = wireRadius, test = test);

              mirror([90, 0, 0])
                wireHolder(h = h * 2, wireRadius = wireRadius, test = test);
              
              if (ring) {
                translate([MARBLE_RADIUS * .95, 0.25,0])
                  mirror([0,1,0])
                    holderCurve(h, wireRadius);
                
                rotate([0,0,180])
                  translate([MARBLE_RADIUS * .95, -0.25, 0])
                    holderCurve(h, wireRadius);
              }
            }  
          }    
    
          translate([0, -6, -h / 2])
            translate([0,2.5,-0.1]) cylinder(h * 2 + 0.2, 2, 2, $fn = 32);      
          
          notchMax = ring ? 4 : 1;
          
          for (i = [0:1:notchMax - 1])
            rotate([0,0,i * 90])
              translate([0, -9.7, -0.1 - h / 2]) 
                cylinder(h * 2 + 0.2, 1.25, 1.25, $fn = 16);  
        }
        
        
        translate([0, -6, -h / 2]) {
          difference() {
            translate([-2.5,-2,0]) cube([5, 3, h * 2]);
            translate([0,2.5,-0.1]) cylinder(h * 2 + 0.2, 2, 2, $fn = 32);
          }
        }
      }
    }
    
    if (test) {
      %translate([0, 0, MARBLE_RADIUS + wireRadius * 2 + 0.1]) 
        rotate([90, 90, 0]) 
          cylinder(2, MARBLE_RADIUS, MARBLE_RADIUS, $fn = 64);
    }
}

module holderCurve(h = DEFAULT_HEIGHT, wireRadius = WIRE_RADIUS) {
   difference() {
    mult = 3;
    cube([wireRadius * mult, wireRadius * mult, h * 2]);
    translate([0,-.4,-0.1]) 
      cylinder(h * 2 + 0.2, wireRadius * mult, wireRadius * mult, $fn = 32);
  }
}

module newBase(h = DEFAULT_HEIGHT, wireRadius = WIRE_RADIUS, baseHeight = 8, baseRadius = DEFAULT_HEIGHT * 1.5) {
  translate([0, h / -2, 0]) {
    difference() {
      translate([0, 0, baseHeight / -2 + 1]) 
        cube([h * 2.5, h + (EXTRUSION_SIZE * 8), baseHeight], center = true);
                  
      translate([0, h / 2, 0])
        bracket(h - 0.02, ring = false, test = false);
      
      translate([0, 0, -baseHeight - 1.45 - (EXTRUSION_SIZE * 2)])
        cylinder(baseHeight, r = wireRadius, $fn = 6);
    }
    
    gripR = 0.6; 
    translate([-h * 1.25, h / 2, 1 - gripR])
      rotate([0, 90, 0])
        cylinder(h, gripR, 0, $fn = 4);
    
    mirror([0,1,0])
      translate([-h * 1.25, h / 2, 1 - gripR])
        rotate([0, 90, 0])
          cylinder(h, gripR, 0, $fn = 4);
    
    
    translate([h * .25, h / 2, 1 - gripR])
      rotate([0, 90, 0])
        cylinder(h, 0, gripR, $fn = 4);
    
    mirror([0,1,0])
      translate([h * .25, h / 2, 1 - gripR])
        rotate([0, 90, 0])
          cylinder(h, 0, gripR, $fn = 4);
  }
}

module screw(
  diameter,
  pitch,
  height,
  thread_size,
  airGap = 0.4,
  internal = false,
  diameterScale = 3.25,
  test = true
) {
  d = diameter + airGap;
  ts = thread_size ? thread_size : internal ? pitch + (airGap * 2) : pitch;

  metric_thread(
    d,
    pitch,
    height,
    square = true,
    internal = internal,
    thread_size = ts,
    test = test == false ? false : $preview
  );
}

module driveRoller(
  radius = ROLLER_OUTER_RADIUS,
  airGap = AIR_GAP,
  wireRadius = WIRE_RADIUS, 
  rimHeight = DEFAULT_RIM_HEIGHT, 
  supportHeight = SUPPORT_HEIGHT,
  taper = DEFUALT_TAPER, 
  gripperRotationOffset = 0,
  $fn = 16
) {
  innerRadius = radius - 0.5;
  height = (rimHeight * 2) + (wireRadius * 2);
  
  difference() {
    union() {
      cylinder(rimHeight, radius + taper + 0.5, radius + taper + 0.5, $fn = $fn / 2);

      rotate([0, 0, 11.25]) 
        translate([0, 0, 1]) { 
          cylinder(wireRadius, innerRadius + taper, innerRadius, $fn = $fn / 1.5);
          
          if (gripperRotationOffset) {
            rotate([0, 0, gripperRotationOffset])
              cylinder(wireRadius, innerRadius + taper, innerRadius, $fn = $fn / 1.5);
          }
          
        }

      
      translate([0, 0, 2]) {
        cylinder(wireRadius, innerRadius, innerRadius + taper, $fn = $fn / 1.5);
        
        if (gripperRotationOffset) {
          rotate([0, 0, gripperRotationOffset])
            cylinder(wireRadius, innerRadius, innerRadius + taper, $fn = $fn / 1.5);
        }
      }
        
      

      translate([0, 0, 3])
        cylinder(rimHeight, radius + taper + 0.5, radius + taper + 0.5, $fn = $fn / 2);
    }
    
    axelSlicer(innerRadius * .66, height, airGap, $fn); 
  }
  
  axel(innerRadius * .66, height, airGap, supportHeight, $fn);
}

module guideRoller(
  radius, 
  height,
  airGap = AIR_GAP,
  supportHeight = SUPPORT_HEIGHT,
  taper = 1, 
  $fn = 128
) {
  difference() {
    union() {
      cylinder(height / 2, radius, radius - taper, $fn = $fn);
         
      translate([0, 0, height / 2])
        cylinder(height / 2, radius - taper, radius, $fn = $fn);
    }
  
    axelSlicer(radius * .66, height, airGap, $fn);
  }
  
  axel(radius * .66, height, airGap, supportHeight, $fn);
}

module axelSlicer(
  radius = 4, 
  height = ROLLER_HEIGHT, 
  airGap = AIR_GAP,
  $fn = 64
) {
  r = radius - airGap;
  
  translate([0, 0, -1]) 
    cylinder(height + 2, r, r, $fn = $fn);
}

module axel(
  radius = ROLLER_RADIUS, 
  height = ROLLER_HEIGHT, 
  airGap = AIR_GAP,
  supportHeight = SUPPORT_HEIGHT,
  $fn = 128
) {
  extraHeight = supportHeight + airGap;
  r = radius - (airGap * 2);
  
  translate([0, 0, -extraHeight])  
    cylinder(height + (extraHeight * 2), r, r, $fn = $fn);
}

module support(
  radius = TRIANGLE_SIDE, 
  height = SUPPORT_HEIGHT,
  airGap = AIR_GAP,
  $fn = 3
) {
  translate([0, 0, -height / 2])
    rotate([0, 0, (360 / $fn) - 90])
      cylinder(height, radius, radius, $fn = $fn, center = true);
}

module rollerFrame(height, airGap, rollerSize, supportSize, supportHeight, debugText = false) {
  offsetZ = (airGap * 2) + supportHeight + rollerSize;
  
  translate([0, airGap, 0]) {
    difference() {
      union() {
        // Support 1
        support(supportSize, supportHeight, airGap, $fn = 3);

        // Support 2
        translate([0, 0, offsetZ])
          support(supportSize, supportHeight, airGap, $fn = 3);
      }
      
      translate([0, 0 - height * 1.5, 1])
        cube([supportSize * 2, height * 2, offsetZ * 2], center = true);
    }
    
    if (debugText) {
      translate([0.5, supportSize / 2, offsetZ - airGap])
        rotate([0, 0, 180])
          linear_extrude(0.5, center = true)
            text(str(airGap), 5, "Courier:bold", spacing = .7, halign = "center");
    }
    
   
    translate([0, supportSize / 2 + 1, (offsetZ / 2) - (supportHeight / 2)])
      cube([supportSize * sqrt(3), 2, supportHeight + offsetZ], center = true);
    }
}

module testRoller(airGap, supportSize, baseWidth, supportHeight, offsetZ) {
    rollerFrame(airGap, supportSize, baseWidth, supportHeight, offsetZ);
    
    guideRoller(GUIDE_RADIUS, ROLLER_HEIGHT, airGap, supportHeight); 
}


*rotate([90, 0, 90])bracket(1.5, test = false, ring = true);

transitionBracket(10);

module twoWireHolders() {
  children();
  mirror([90, 0, 0]) children();
}

module transitionBracket(
  h = DEFAULT_HEIGHT, 
  wireRadius = WIRE_RADIUS, 
  holderWidth = EXTRUSION_SIZE * 6,
  test = $preview
) {
  innerMult = 0.7; 
  outerR = MARBLE_RADIUS + EXTRUSION_SIZE * 14; 
  innerR = MARBLE_RADIUS + EXTRUSION_SIZE * 7 * innerMult;
  angle = -8;
  zCos = (wireRadius + holderWidth) * -1 * cos(angle);
  
  difference() {
    translate([0, -zCos / 2, 0])
      difference() {
        union() {
          cylinder(h / 5, outerR * 0.92, outerR, $fn = 64);          
          translate([0, 0, h / 5])
            cylinder(3 * h / 5, r = MARBLE_RADIUS + EXTRUSION_SIZE * 14, $fn = 64);
          
          translate([0, 0, 4 * h / 5])
            cylinder(h / 5, outerR, outerR * 0.92, $fn = 64);          
        }
        
        translate([0,0,-0.1])
          cylinder(h * 1.5 + 0.2, r = innerR, $fn = 64);
      }
    
    rotate([-angle, 0, 0]) {
      twoWireHolders()
        wireHolder(
          h = h, 
          wireRadius = wireRadius, 
          slicer = true, 
          test = test
        );
    }
    
    translate([0, innerR - wireRadius * 2, 0])
      rotate([angle, 0, 180]) {
        twoWireHolders()
          wireHolder(
            h = h, 
            wireRadius = wireRadius, 
            slicer = true, 
            test = test
          );
      }

for (i = [1.5, 3, 4, 5.5, 7, 8])      
  translate([0,wireRadius * 1.75,0])
  rotate([0, 0, i * 45 + 22.5])
    translate([innerR + wireRadius * 1.414, 0, -0.1])
      cylinder(h + 0.2, r = wireRadius, $fn = 16);
  } 
}