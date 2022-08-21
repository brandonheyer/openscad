include <./constants.scad>;
use <./library.scad>;

SPACING_OFFSET = 6;
GAP = 2;
RING_THICKNESS = 5;
SIZES=[10, 20];
Y_OFFSETS=[0, 60];
BIGGEST = 20;
HEIGHT = 5;
FONT_SIZE = 4;

module rollerTube(outer, inner, h, sizeText) {
    o = max(outer, inner);
    i = min(outer, inner);
    
    spaceSize = WIRE_DIAMETER * 1.1;
    topHeight = (h - spaceSize) / 2;

    union() {
        tube(o + (WIRE_RADIUS * 3), i, topHeight, $fn=16);

        translate([0, 0, topHeight]) {
            tube(o - WIRE_DIAMETER, i, spaceSize, $fn=16);
            tube(o - WIRE_RADIUS, i, spaceSize, $fn=128);
        }
        
        translate([0, 0, topHeight + spaceSize]) {
            o = o + (WIRE_RADIUS * 2);
            tube(o, i, topHeight, $fn=16);
            
            translate([0, o - ((o - i) / 2) - (FONT_SIZE / 2), topHeight])
            linear_extrude(1)
                text(str(sizeText), FONT_SIZE, "Helvetica", halign = "center");
        }
    }
}



for (i = [0, len(SIZES) - 1]) {
    currSize = SIZES[i];
    translate([0, Y_OFFSETS[i], 0]) {
        rollerTube(currSize - RING_THICKNESS, currSize, HEIGHT, currSize); 
        
        biggerSize = SIZES[i] + SPACING_OFFSET;
        translate([(BIGGEST + SPACING_OFFSET + (WIRE_DIAMETER * 2)) * 2, 0, 0])
            rollerTube(biggerSize, biggerSize - RING_THICKNESS, HEIGHT, currSize);
    }
}