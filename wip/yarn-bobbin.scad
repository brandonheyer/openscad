$fn = 64;
%circle(50);


for (i = [0 : 1 : 2]) {
  translate([0, 0, i * 2.8])
  union() {
    rotate([180, 0, 0])
      linear_extrude(0.8, scale = 0.99) bobbin();
      
      translate([0, 0, 0]) 
        linear_extrude(0.4)
          bobbin();
    
      translate([0, 0, 0.4])
        linear_extrude(0.8, scale = 0.99)
            bobbin();
  }
}

module bobbin() {
  bobbin50();
}

module bobbin50() {
  union()
    difference() {
      scale(0.35)
        union() {
          for (i = [0 : 1 : 4])
            rotate([0, 0, i * 72]) 
              translate([-70, 0]) 
                scale([1.8, .3]) 
                  circle(40);
          
          circle(r = 60);
        }
      
      scale(0.35)
        for (i = [0 : 1 : 4])
          rotate([0, 0, i * 72]) 
            translate([-80, 0]) 
              scale([1.5, .1]) 
                offset(-0.4 * 8)
                  circle(40);
      
      scale(0.35)
        for (i = [0 : 1 : 4])
          rotate([0, 0, 36 + i * 72]) 
            translate([-80, 0]) 
               scale([3.075, 2])
                  circle(15);
        
      
      circle(r = 6.4);
    }
}

%bobbin80();

module bobbin80() {
  union()
    difference() {
      scale(0.35)
        union() {
          for (i = [0 : 1 : 4])
            rotate([0, 0, i * 72]) 
              translate([-115, 0]) 
                scale([1.8, .3]) 
                  circle(60);
          
          circle(r = 100);
        }
      
      scale(0.35)
        for (i = [0 : 1 : 4])
          rotate([0, 0, i * 72]) 
            translate([-117, 0]) 
              scale([1.6, .15]) 
                offset(-0.4 * 8)
                  circle(60);
      
      scale(0.35 )
        for (i = [0 : 1 : 4])
          rotate([0, 0, 36 + i * 72]) 
            translate([-152, 0]) 
               scale([3, 2])
                  circle(30);
        
      
      circle(r = 6.4);
    }
}