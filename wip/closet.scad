LH = 0.28;
DOOR_DEPTH = 21.2;

X1 = 0;
Y1 = 0;

X2 = 12;
Y2 = DOOR_DEPTH / 2;

X3 = X1 + 3.2;
Y3 = Y2 + 2;

R = 2;
MH = 15.2;
PAD = 1.6;
H = MH + PAD * 2;




difference() {
  linear_extrude(H)
    intersection() {
      union() {
        translate([R, -Y3, 0]) 
          square([X2 - R, Y3 * 2]);

        translate([0, -Y3 + R, 0]) 
          square([X2, Y3 * 2 - R * 2]);

        translate([R,-Y3 + R,0])
          circle(R, $fn = 16);
          
        translate([R,Y3 - R,0])
          circle(R, $fn = 16);
      }
      
      polygon([
        // CENTER
        [X1, Y1],
    
        [X1, Y2],          
        [X1, Y3],       
        [X2, Y3],
        [X2, Y2],
        [X3, Y2],
        
        [X3, Y1],

        [X3, -Y2],
        [X2, -Y2],
        [X2, -Y3],       
        [X1, -Y3],
        
        [X1, -Y2]
       ]);
    }
     
  // -1.6
  translate([0.8, -MH / 2, PAD])
    cube([3, MH, MH]);
}