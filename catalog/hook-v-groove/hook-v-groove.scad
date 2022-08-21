/* [General Settings] */

// Height of the support base
Base_Height = 30;

// The offset radius of the base
Base_Offset = 2;

// Use to shave the top and bottom, will remove shallow overhangs from final print. Will use smaller of this or Base Height
Final_Height = 24;

$fn = 32;

/* [Peg Settings] */

// Width of the peg hook
Peg_Size = 30;

// The radius of the peg hook, to middle of hook
Peg_Rotation_Radius = 40;

// The rotation angle of the peg hook
Peg_Rotation_Angle = 45;

BASE_D = Base_Height + 10;
BASE_D_2 = BASE_D / 2;
BASE_D_4 = BASE_D / 4;
BASE_OFFSET = Base_Offset;

PEG_D = Peg_Size - 10;
PEG_R = Peg_Rotation_Radius;
PEG_THETA = Peg_Rotation_Angle;

ex = PEG_D + 10;

module peg(angle = 45) {
  translate([-BASE_D_4 / 2,  -BASE_D_4, 0]) {
    intersection() {
      translate([0, 0, ex / 2])
        translate([PEG_R, 0, 0])
          rotate_extrude(angle = angle, $fn = $preview ? 48 : 128)
            translate([-PEG_R, 0])
              scale([0.5, 1.025])
                circle(d = ex);
      
      translate([BASE_D_2, -BASE_D_2, 0])
        linear_extrude(ex)
          square(
            BASE_D * 4, center = true
          );
    }
  }
}

intersection() {
  union() {
    difference() {
      translate([-BASE_D_2, -BASE_D_4])
        linear_extrude(ex)
          offset(r = BASE_OFFSET)
            offset(delta = -BASE_OFFSET)
              square([BASE_D, BASE_D_2]);
      
      translate([cos(45) * -ex * 2 - BASE_D / 3, 0, ex / 2])
        rotate([0, 0, 45])
          cube(ex * 2, center = true);
      
      translate([cos(45) * ex * 2 + BASE_D / 3, 0, ex / 2])
        rotate([0, 0, 45])
          cube(ex * 2, center = true);
    }

    peg(PEG_THETA - 10);

    intersection() {
      peg(PEG_THETA + PEG_R);
      
      translate([PEG_R - BASE_D_4 / 2, -BASE_D_4, 0]) 
        mirror([0, 1, 0]) 
          rotate([0, 0, -PEG_THETA])
            translate([-PEG_R, 0, ex / 2])
              rotate([0, 0, -15])  
                scale([.5, 1, .8])
                  sphere(PEG_D * 1.2, $fn = $preview ? 32 : 64);
    }
  }
  
  translate([BASE_D_2, -BASE_D_2, -(Final_Height - ex) / 2])
    linear_extrude(min(Final_Height, Base_Height))
      square(
        BASE_D * 4, center = true
      );
}