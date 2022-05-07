DEBUG_LAYER = 10;
WIRE_DIAMETER = 2;
WIRE_RADIUS = WIRE_DIAMETER / 2;
MARBLE_DIAMETER = 9.5;
MARBLE_RADIUS = MARBLE_DIAMETER / 2;
HOLDER_WIDTH = 1.5;
DEFAULT_SPACE_OFFSET = 1.1;
DEFAULT_HEIGHT = 2;
SQRT22 = sqrt(2) / 2;

module tube(inner, outer, h = DEFAULT_HEIGHT, $fn = 32) {
    in = min(outer, inner);
    out = max(outer, inner);
    
    difference() {
        cylinder(h, out, out, $fn);
        translate([0, 0, -1]) 
            cylinder(h+2, in, in,  $fn);
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



module wireHolder(scale = 1, rotate = -135, width = 1, h = DEFAULT_HEIGHT) {
    wireRadius = WIRE_RADIUS * scale;
    
    difference() {
        rotate([0, 0, rotate])
            translate([MARBLE_RADIUS + wireRadius, 0, 0]) {
                cutSide = wireRadius * 3;
                
                difference() {   
                    tube(wireRadius, cutSide * 1.1, h);
                                        
                    rtCube(cutSide, cutSide, -wireRadius * 2 * SQRT22, 80, true, h, $center = true, $posY = cutSide * SQRT22);                rtCube(cutSide, cutSide, -wireRadius * 2.5 * SQRT22, 45, true, h, $center = true, $posY = cutSide * SQRT22);        

                    rtCube(
                        MARBLE_RADIUS * 2, 
                        MARBLE_RADIUS * .8, 
                        -wireRadius, 
                        60, 
                        true, 
                        h, 
                        $center = true, 
                        $posY = (wireRadius * SQRT22) + (MARBLE_RADIUS * SQRT22)
                    );                
                }
                
        }
    }
   
    translate([MARBLE_RADIUS + (wireRadius * 2.2), 0, 0])
        rtCylinder(wireRadius * 3, wireRadius * 3, rotate - 15, 0, $fn = 3, $posY = (wireRadius * 7.4 * (sqrt(2) / 2)));
}

module base(holderOffset, scale = 1, h = DEFAULT_HEIGHT) {
    wireRadius = WIRE_RADIUS * scale;
    
    difference() {
        rtCube(
            MARBLE_DIAMETER * 1.25, 
            h, 
            -MARBLE_RADIUS * 1.25,
            0,
            false,
            h,
            $posY = -holderOffset - (DEFAULT_HEIGHT * .9)
        );


        rotate([0, 0, -45])
            translate([MARBLE_RADIUS + wireRadius, 0, -2])
                cylinder(h + 4, wireRadius, wireRadius, $fn=32); 
        
        rotate([0, 0, -135])
            translate([MARBLE_RADIUS + wireRadius, 0, -2])
                cylinder(h + 4, wireRadius, wireRadius, $fn=32); 
                    
    }
}

module bracket(scale = 1, h = DEFAULT_HEIGHT) {
    wireRadius = WIRE_RADIUS * scale;
    holderOffset = ((MARBLE_RADIUS + wireRadius) * sqrt(2) / 2) + wireRadius;

    translate([0, 0, holderOffset + DEFAULT_HEIGHT * .9]) 
        rotate([90, 0, 0])  {
            // FULL BASE    
            difference() {
                union() {
                    wireHolder(scale);
                    mirror([90, 0, 0])
                        wireHolder(scale);
                   
                   *base(holderOffset, scale, h);
                    

                    *color("#ff0000") {
                        circle(MARBLE_RADIUS, $fn=32);
                        
                        rotate([0, 0, -135])
                            translate([MARBLE_RADIUS + WIRE_RADIUS, 0, -1])
                                circle(WIRE_RADIUS, $fn=32); 
                        
                        rotate([0, 0, -45])
                            translate([MARBLE_RADIUS + WIRE_RADIUS, 0, -1])
                                circle(WIRE_RADIUS, $fn=32); 
                    }
                    
                }               
            }      
    }
}



baseScale = 1;
spacing = 1.5;
lastY = 0;

for(s = [1:1:1]) {
    gap = (DEFAULT_HEIGHT * baseScale) + (spacing + (s * 1));
    translateY = (s * 3) * (lastY + gap);
    lastY = translateY;

    for(i = [1:1:1]) { 
        theScale = baseScale + (i * .05);
        baseWidth = MARBLE_DIAMETER + (WIRE_RADIUS * theScale * 3 * 2);
        
        for(j = [1:1:1]) { 
            translate([0, translateY + (gap * j), 0]) {
                difference() {
                    union() {
                        difference() {

                            bracket(theScale);
                           
                            translate([0, 0, -2]) rtCube(20, 10, 0, 0, $center = true);
                            
                            rotate([90, 0, 0])
                                translate([0, 2 * SQRT22, -1])
                                    tube(MARBLE_RADIUS * 1.6, MARBLE_DIAMETER * 2, (DEFAULT_HEIGHT * theScale) + 2, $fn = 64);
                       }
                       

                        translate([-baseWidth / 2, 1, 0])
                            rotate([90, 0, 0]) {
                                rtCube(baseWidth, WIRE_DIAMETER * .8, 0, 0, h = DEFAULT_HEIGHT + 2);
                                translate([1, -1, 1])
                                    rtCube(baseWidth - 2, 1, 0, 0, h = DEFAULT_HEIGHT);
                                translate([0, -2, 0])
                                    rtCube(baseWidth, 1, 0, 0, h = DEFAULT_HEIGHT + 2);
                            }
                    } 
              
                    translate([-MARBLE_DIAMETER, -DEFAULT_HEIGHT - 1, WIRE_DIAMETER * 2 + 1])
                        rtCube(MARBLE_DIAMETER * 2, DEFAULT_HEIGHT + 2, 0, 0, h = WIRE_DIAMETER * 2);  
                }
            }
            
        }
    }
}