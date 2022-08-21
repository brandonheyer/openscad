path = "C:/Users/Brandon/openscad/batamfans2.stl";

module ductSlice2(slicePoint) {
  projection()
    rotate([-90, 0, -90])
      ductPart(slicePoint);
}

module ductSlice(slicePoint) {
  projection()
    rotate([-90, 0, 0])
      ductPart(slicePoint);
}

module ductPart(slicePoint) {
  intersection() {
    import(path, 1, 3);

    translate([0, slicePoint, 0])
      cube([60, 0.1, 60]);
  }
}

translate([42.25, -18.05, 1.68])
  rotate([-15, 0, -30])
    group() {
      xOffset = -52;
      slicePoint = -70;
      sliceSize = 60;

      translate([0, 13, 1.76])
        rotate([15, 0, 0]) {
          translate([xOffset, -slicePoint, 0])
            intersection() {
              import(path, 1, 3);

              translate([0, slicePoint, 0])
                cube([60, sliceSize, 60]);
            }
            
            
          translate([xOffset, 0, -xOffset])
            rotate([0, 270, 0])
              rotate_extrude(angle = 15, $fn = 256) 
                translate([xOffset, 0, 0]) 
                  ductSlice2(slicePoint);

        }

  translate([-15, 0, 0])
      rotate([0, 0, 30]) {
        translate([xOffset + 15, -slicePoint, 0])
          difference() {
            intersection() {
              import(path, 1, 3);

              translate([0, slicePoint - sliceSize, 0])
                cube([60, sliceSize, 60]);
            }
            
            linear_extrude(40)
              translate([10.9, -86.9])
                rotate([0, 0, 180])
                  polygon([
                    [0, 0],
                    [-9.51, 0],
                    [-9.5, 5],
                    [-9.25, 6],
                     
                    [-9, 6.6],
                    [-8.45, 7.51],
                    [-0.6, 21.1],
                    [1, 21]
                  ]);
          }       
         
          rotate([0, 0, -30])
            rotate_extrude(angle = 30, $fn = 256)
              translate([xOffset + 15, 0, 0])
                ductSlice(slicePoint);
        }
        
        
        

}

translate([-1, -32, 15]) {
  rotate([0, 0, 60])
    translate([14.5, -14.5, -9]) {
      difference() {
        linear_extrude(22) 
          difference() { 
            minkowski() {
              circle(5, $fn = 128);
              square([10, 20]);
            }
            
            translate([0, 8.8])
              polygon([
                [-5, -8.1],
                [0, -5.6],
                [9, -0.2],
                [12, 1.4],
                [15.2, 3.2],
                [15, -20],
                [-5, -20]
              ]);
          }
        
        rotate([7, 15, 30])
          translate([-20, -34.5, 5])
            cube([40, 40, 30]);   
          
        rotate([-60, -0, 70])
          translate([-10, -23, 12])
            cube([40, 40, 20]); 
          
        rotate([0, 15, 0])
          translate([-12, -14, 2.806 - 20])
            cube([40, 40, 20]);
        
        rotate([0, -45, 0])
          translate([-5, -10, -17.2])
            cube([40, 40, 20]);
          
        translate([10, 20, 10]) {
          cylinder(h = 15, d = 3.2, $fn = 64);
          cylinder(h = 5, d = 6.2, $fn = 64);
        }
          
      }
    }
  }
  