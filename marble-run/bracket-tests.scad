DEBUG_LAYER = 10;
WIRE_DIAMETER = 2;
WIRE_RADIUS = WIRE_DIAMETER / 2;
MARBLE_DIAMETER = 9.5;
MARBLE_RADIUS = MARBLE_DIAMETER / 2;
HOLDER_WIDTH = 1.5;
DEFAULT_SPACE_OFFSET = 1.1;
DEFAULT_HEIGHT = 3;

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
                difference() {
                    tube(wireRadius, wireRadius * 3, h);           
                    
                    cutSide = (wireRadius + 1) * 2;
                    rotate([0, 0, 90]) 
                        rtCube(cutSide + 10, cutSide, 0, 0, true, h, $center = true, $posY = cutSide / 1.5);        
                }
            }
            
            translate([0, -MARBLE_DIAMETER * 1, -1])
                tube(MARBLE_DIAMETER, MARBLE_DIAMETER * 1.5, DEFAULT_HEIGHT + 2, $fn = 64);
    }
    

    translate([MARBLE_RADIUS + (wireRadius * 2.2), 0, 0])
        rtCylinder(wireRadius * 3, wireRadius * 3, rotate - 15, 0, $fn = 3, $posY = (wireRadius * 7.4 * (sqrt(2) / 2)));
}

module baseRemoval(holderOffset, wireRadius) {
    translate([-MARBLE_RADIUS * .19, -MARBLE_DIAMETER * .75, 0])
        rotate([0, 0, 45])
            rtCube(MARBLE_DIAMETER, MARBLE_DIAMETER * 1.25, 0, 0, true, $posY = -(holderOffset * 2 * .9) - MARBLE_RADIUS - wireRadius);
}

module bracket(scale = 1) {
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
                   

                    // BASE
                    difference() {
                        rtCube(
                            MARBLE_DIAMETER * 1.25, 
                            DEFAULT_HEIGHT * 1, 
                            -MARBLE_RADIUS * 1.25,
                            0, 
                            h = DEFAULT_HEIGHT, 
                            $posY = -holderOffset - (DEFAULT_HEIGHT * .9)
                        );


                        rotate([0, 0, -45])
                            translate([MARBLE_RADIUS + wireRadius, 0, -2])
                                cylinder(DEFAULT_HEIGHT + 4, wireRadius, wireRadius, $fn=32); 
                        
                        rotate([0, 0, -135])
                            translate([MARBLE_RADIUS + wireRadius, 0, -2])
                                cylinder(DEFAULT_HEIGHT + 4, wireRadius, wireRadius, $fn=32); 
                                    
                    }
                    

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
                
                // BASE REMOVAL
                *baseRemoval(holderOffset, wireRadius);

           
                *mirror([90, 0, 0])
                   baseRemoval(holderOffset, wireRadius);
            }      
    }
}

baseScale = .95;
for(i = [1:1:2]) { 
    for(j = [0:1:3]) { 
        translateY = 12 * i;
        translate([j * 18, translateY, 0]) {
           difference() {
               bracket(baseScale + (i * .05));
               
             translate([0, 0, -1.8]) rtCube(20, 10, 0, 0, $center = true);
           }
        }
    }
}