INSET = -0.4;

XS = [1, 4, 10, 13];
YS = [0, 3, 5];

module base() {
  polygon([
    [XS[1], YS[0]],
    [XS[2], YS[0]],
    [XS[3], YS[1]],
    [XS[3], YS[2]],
    [XS[2], YS[1]],
    [XS[1], YS[1]],
    [XS[0], YS[2]],
    [XS[0], YS[1]]
  ]);
}

module link(gap = .2, hole = 2, caboose = true, engine = true) {
  if (engine) {
    translate([0, 0, -15]) {
        translate([0, 0, 8])
        linear_extrude(7)
          polygon([
            [XS[1],YS[0]],
            [XS[1],YS[1]],
            [XS[0],YS[1]]
          ]);

      difference() {
        union(){
        linear_extrude(11.1)
          polygon([
            [XS[1],YS[0]],
            [XS[1],YS[1]],
            [XS[0],YS[2]],
            [XS[0],YS[1]]
          ]);
        
        translate([(YS[2] - YS[1]) /2, 3, 0]) 
            cube([(YS[2] - YS[1]) * 1.5, 2, hole * 7.5]);
        }
      
        translate([0, hole + gap + XS[0] / 2 + .4, 4])
          rotate([90, 0, 90])
            cylinder(XS[3] - XS[0], hole, hole, $fn = 32);
        
        translate([0, 5.75, -2.85]) 
          rotate([45, 0, 0])  
            cube((YS[2] - YS[1]) * 2);
            
        translate([0, 5.75, 8.35]) 
          rotate([45, 0, 0])  
            cube((YS[2] - YS[1]) * 2);
      }
      
    

      translate([0, 0, 8])
        linear_extrude(7)
            polygon([
              [XS[2],YS[0]],
              [XS[3],YS[1]],
              [XS[2],YS[1]]
            ]);
        
      translate([0,0,0])
        difference() {
          union() {
          linear_extrude(11.1)
            polygon([
              [XS[2],YS[0]],
              [XS[3],YS[1]],
              [XS[3],YS[2]],
              [XS[2],YS[1]]
            ]);
          
                  translate([10, 3, 0]) 
            cube([(YS[2] - YS[1]) * 1.5, 2, hole * 7.5]);
        
      }
          translate([4, hole + gap + XS[0] / 2 + .4, 4])
            rotate([90, 0, 90])
              cylinder(XS[3] - XS[0], hole, hole, $fn = 32);
          
          translate([XS[3] - XS[0] - 2.5, 5.75, -2.85]) 
            rotate([45, 0, 0])  
              cube((YS[2] - YS[1]) * 2);
          
          translate([XS[3] - XS[0] - 2.5, 5.75, 8.35]) 
            rotate([45, 0, 0])  
              cube((YS[2] - YS[1]) * 2);
        }
        
    }
  }
  
  difference() {
    linear_extrude(10) base();
  
    translate([0, XS[1] - XS[0], -1]) 
      cube([(YS[2] - YS[1]) * 2, (YS[2] - YS[1]) * 2, 20]);
    
    translate([XS[3] - XS[0] - 2.5, XS[1] - XS[0], -1]) 
      cube([(YS[2] - YS[1]) * 2, (YS[2] - YS[1]) * 2, 20]);
  }
  
    if (caboose) {
    translate([0, 0, 10]) {
      linear_extrude(5)
        polygon([
          [XS[1] - INSET, YS[0]],
          [XS[2] + INSET, YS[0]],
          [XS[2] + INSET, YS[1]],
          [XS[1] - INSET, YS[1]]
        ]);
      
      intersection() { 
        translate([0, 2, 5])
          rotate([90, 0, 90]) {
            *translate([-.25, 0, INSET / 4]) 
              cylinder(5 - INSET / 2, hole, hole, $fn = 32);
              
            translate([
              (YS[1] - YS[0]) / -2 - (XS[0] / 2), 
              1, 
              XS[0] + (XS[2] - XS[1])
            ])         
              rotate([0, 90, 0])
                cylinder(
                    YS[1] - YS[0], 
                    d = (XS[2] - XS[1]) + INSET + INSET, 
                    $fn = 16
                  );
            
            translate([gap + gap + gap, 0, XS[0]]) 
              cylinder(
                XS[3] - XS[0], 
                hole - (gap * 2), 
                hole - (gap * 2), 
                $fn = 32
              );
          }
              
        translate([0,0,3]) {
          linear_extrude(5)
            base();
        }
      }
    }
  }
}

MAX = 144;

for (i = [0 : 36 : MAX]) {
  *translate([0, 0, i]) link();
}

translate([20, 0 ,0]) {
  for (i = [0 : 36 : MAX]) {
    *translate([0, 0, i]) link(.4);
  }
}

for (i = [0 : 26 : MAX]) {
  translate([0, 0, i]) link(.16, 1.5, i < MAX - 26, i != 0);
}