DEBUG_LAYER = 10;
WIRE_DIAMETER = 2;
WIRE_RADIUS = WIRE_DIAMETER / 2;
MARBLE_DIAMETER = 9.5;
MARBLE_RADIUS = MARBLE_DIAMETER / 2;
HOLDER_WIDTH = 1;
DEFAULT_SPACE_OFFSET = 1.3;
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

module wireHolders(h, wireRadius, marbleRadius, angle = 120, spaceOffset = DEFAULT_SPACE_OFFSET) {
    innerRadius = wireRadius * spaceOffset;
    outerRadius = innerRadius + HOLDER_WIDTH;
    halfRadius = innerRadius + ((outerRadius - innerRadius) / 2);
    wireGrip = (outerRadius - innerRadius) * .8;
    
    rotate([0, 0, angle])
        translate([0, marbleRadius + wireRadius, 0]) {
            union() {
                difference() {
                    tube(h, innerRadius, outerRadius);
                    
                    rotate(250) 
                        translate([0, 0, -1]) 
                            cube([outerRadius, outerRadius * 1.1, h + 2]);            
                    
                    rotate(-250) 
                        translate([-outerRadius, 0, -1]) 
                            cube([outerRadius, outerRadius * 1.1, h + 2]);
                }
               
                rotate(190)
                    translate([halfRadius, 0, 0])
                        cylinder(h, wireGrip, wireGrip, $fn = 16);
                
                rotate(350)
                    translate([halfRadius, 0, 0])
                        cylinder(h, wireGrip, wireGrip, $fn = 16);
            }
        }
}

module cap(h, radius, posX, rotate) {
    rotate(rotate)
        translate([posX, 0, 0])
            cylinder(h, radius, radius, $fn = 32);
}
    
// 9.5mm marble
// 2mm wire


//////
// MAIN BRACKET
//////
difference() {
union() {
    ringInnerRadius = MARBLE_RADIUS + (WIRE_RADIUS * DEFAULT_SPACE_OFFSET);
    ringOuterRadius = ringInnerRadius + (HOLDER_WIDTH * 2);
    ringSubtractionRadius = (ringInnerRadius - MARBLE_RADIUS) * 1.1;

    capRadius = ((ringOuterRadius * 1.1) - (ringInnerRadius * 0.9)) / 2;
    capPosX = (ringInnerRadius * .9) + capRadius;
    
    // CAP LEFT
    cap(DEFAULT_HEIGHT, capRadius, capPosX, 180);
    cap(DEFAULT_HEIGHT, capRadius, capPosX, 0);
    
    // HOLDER SPACE REMOVAL
    difference() {
        tube(DEFAULT_HEIGHT, ringInnerRadius * .9, ringOuterRadius * 1.1, $fn = 64);
        
        rotate(210)
            translate([ringInnerRadius, 0, -1])
                cylinder(DEFAULT_HEIGHT + 2, ringSubtractionRadius, ringSubtractionRadius, $fn = 16);

        rotate(330)
                translate([ringInnerRadius, 0, -1])
                    cylinder(DEFAULT_HEIGHT + 2, ringSubtractionRadius, ringSubtractionRadius, $fn = 16);
       
        rotate(180)
                translate([ringSubtractionRadius * -12, -ringSubtractionRadius * 10, -1])
                    cube([ringSubtractionRadius * 20, ringSubtractionRadius * 10, ringSubtractionRadius * 2 + (2 * DEFAULT_HEIGHT)]);
        
        rotate(0)
                translate([ringSubtractionRadius * -12, 0, -1])
                    cube([ringSubtractionRadius * 20, ringSubtractionRadius * 10, ringSubtractionRadius * 2 + (2 * DEFAULT_HEIGHT)]);
    }
    

        union() {
            SUPPORT_CARVE_RADIUS = 3.5;
            SUPPORT_CARVE_OFFSET = SUPPORT_CARVE_RADIUS * 1.75;
            bracketY = -1 * (MARBLE_RADIUS + (WIRE_RADIUS * DEFAULT_SPACE_OFFSET) + (HOLDER_WIDTH * 2) + (SUPPORT_CARVE_RADIUS / 2) + .9);
            
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



wireHolders(DEFAULT_HEIGHT, WIRE_RADIUS, MARBLE_RADIUS, 120);
wireHolders(DEFAULT_HEIGHT, WIRE_RADIUS, MARBLE_RADIUS, -120);

*color("#ff0000") {
    *circle(MARBLE_RADIUS, $fn=32);
    *translate([0,-5,1.5]) 
        linear_extrude(3)
            import("track-bracket-180-3.svg", center=true);

}
