DEBUG_LAYER = 10;
WIRE_DIAMETER = 2;
WIRE_RADIUS = WIRE_DIAMETER / 2;
MARBLE_DIAMETER = 9.5;
MARBLE_RADIUS = MARBLE_DIAMETER / 2;
HOLDER_WIDTH = 1.5;
DEFAULT_SPACE_OFFSET = 1.1;
DEFAULT_HEIGHT = 4;

module tube(h, outer, inner, $fn = 32) {
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

module rtCube(width, length, posX, rotate, isTrim = false, h = DEFAULT_HEIGHT) {
    rotate(rotate) {
        if (isTrim) {
            translate([posX, 0, -1])
                cube([width, length, h + 2]);
        } else {
            translate([0, 0, 0])            
                cube([width, length, h]);
        }
    };
}

module wireHolders(h, wireRadius, marbleRadius, angle = 120, spaceOffset = DEFAULT_SPACE_OFFSET, $innerRotate = 0) {
    innerRadius = wireRadius * spaceOffset;
    outerRadius = innerRadius + HOLDER_WIDTH;
    halfRadius = innerRadius + ((outerRadius - innerRadius) / 2);
    wireGrip = 1;
    
    rotate([0, 0, angle])
        translate([0, marbleRadius + (wireRadius * .7), 0]) {
            rotate($innerRotate)
            union() {
                difference() {
                    tube(h, innerRadius, outerRadius * 1.2);
                    
                    translate([0,-.8,0])
                    rtCube(outerRadius * 4, outerRadius * 4, 0, 290, true);
                    
                    translate([.4, .4, 0])
                    rtCube(outerRadius * 2.8, outerRadius * 3, -3 * outerRadius, -250, true);
                }
               
                // SNAPS
                rtCylinder(wireGrip * 1.3, halfRadius * 1.05, 185, $fn=3, $innerRotation=-80, $posY = .15);
                *rtCylinder(wireGrip * .8, halfRadius * 1., 350, $fn=5, $innerRotation=-150, $posY = -.02);
            }
        }
}


    
// 9.5mm marble
// 2mm wire


//////
// MAIN BRACKET
//////
difference() {
union() {
    ringInnerRadius = MARBLE_RADIUS + (WIRE_RADIUS * DEFAULT_SPACE_OFFSET);
    ringOuterRadius = ringInnerRadius * 1.3;
    ringSubtractionRadius = (ringInnerRadius - MARBLE_RADIUS) * 1.1;
    ringTrimX = ringSubtractionRadius * -8;
    ringTrimWidth = ringSubtractionRadius * 10;
    ringTrimHeight = ringSubtractionRadius * 2 + (2 * DEFAULT_HEIGHT);

    capRadius = ((ringOuterRadius * 1.1) - (ringInnerRadius * 0.9)) / 2;
    capPosX = (ringInnerRadius * .9) + capRadius;
    
    // CAP LEFT
    *rtCylinder(capRadius, capPosX, 180);
    *rtCylinder(capRadius, capPosX, 0);
    
    // HOLDER SPACE REMOVAL
    difference() {
        tube(DEFAULT_HEIGHT, ringInnerRadius * 1.1, ringOuterRadius * 1.1, $fn = 64);
        
        rtCylinder(ringSubtractionRadius, ringInnerRadius, 220, true);
        rtCylinder(ringSubtractionRadius, ringInnerRadius, 320, true);
        

            rotate(220)
                translate([ringTrimX, -1 * ringTrimWidth, -1])
                    cube([ringTrimWidth * 2, ringTrimWidth, ringTrimHeight]);
        
            rotate(-40)
                translate([ringTrimX, 0, -1])
                    cube([ringTrimWidth * 2, ringTrimWidth, ringTrimHeight]);
    }
    

    union() {
            SUPPORT_CARVE_RADIUS = 3;
            SUPPORT_CARVE_OFFSET = SUPPORT_CARVE_RADIUS * 1.75;
            bracketY = -1 * (MARBLE_RADIUS + (WIRE_RADIUS * DEFAULT_SPACE_OFFSET) + (HOLDER_WIDTH * 2) + (SUPPORT_CARVE_RADIUS / 2) - .25);
            
            difference() {
                translate([-SUPPORT_CARVE_OFFSET, bracketY, 0])
                    cube([SUPPORT_CARVE_OFFSET * 2, SUPPORT_CARVE_OFFSET / 2, DEFAULT_HEIGHT]);

                translate([-SUPPORT_CARVE_OFFSET, bracketY, -1])
                    cylinder(DEFAULT_HEIGHT + 2, SUPPORT_CARVE_RADIUS, SUPPORT_CARVE_RADIUS, $fn = 32);

                translate([SUPPORT_CARVE_OFFSET, bracketY, -1])
                    cylinder(DEFAULT_HEIGHT + 2, SUPPORT_CARVE_RADIUS, SUPPORT_CARVE_RADIUS, $fn = 32);
            }
            
            translate([SUPPORT_CARVE_RADIUS * -.75, bracketY - SUPPORT_CARVE_OFFSET / 2, 0])
                cube([SUPPORT_CARVE_RADIUS * 1.5, SUPPORT_CARVE_OFFSET / 2, DEFAULT_HEIGHT]);
        }
    }
    
    rotate([90, 0, 0])
        translate([0, DEFAULT_HEIGHT / 2, 7])
            cylinder(20, WIRE_RADIUS * 1.2, WIRE_RADIUS * 1.2, $fn = 16);
    }



wireHolders(DEFAULT_HEIGHT, WIRE_RADIUS, MARBLE_RADIUS, 120, $innerRotate = -4);
mirror([90, 0, 0]) wireHolders(DEFAULT_HEIGHT, WIRE_RADIUS, MARBLE_RADIUS, 120, $innerRotate = -4);

color("#ff0000") {
    translate([0, .4, 0])
           circle(MARBLE_RADIUS, $fn=32);
    
    translate([4.77, -2.78, 0])
    circle(WIRE_RADIUS, $fn=32);
    *translate([0,-5,1.5]) 
        linear_extrude(3)
            import("track-bracket-180-3.svg", center=true);

}
