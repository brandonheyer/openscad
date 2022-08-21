module coverEdge(e = 10) {
    projection()
      rotate([0, 90, 0])
        translate([-120, -4, 41])
          intersection() {
            import(
              "./originals/lily58-top.stl", 
              convexity = 4
            );
            
            translate([120, 4, -41]) 
              cube([4, 12, 5]);
        }
}

module linearEdge(e = 10) {
  linear_extrude(e)
    coverEdge();
}

module rotateEdge(angle = 90, t = 0) {
  rotate_extrude(angle = angle)
    translate([t, 0, 0])
    coverEdge();
}