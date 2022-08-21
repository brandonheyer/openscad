module bin(height = 20, size = 10, wall = 1.5) {
  difference() {
    linear_extrude(height, $fn = 32)
      offset(wall * 2)
        circle(size - (wall * 2), $fn = 6);
    
    translate([0, 0, - 1])
      linear_extrude(height + 2, $fn = 32)
        offset(wall * 2)
          circle(size - (wall * 2) - wall, $fn = 6);
  }
  
    translate([0, 0, -3.9])
      linear_extrude(4, scale = 1.095, $fn = 32)
        offset(wall * 2)
          circle(size - (wall * 2) - wall - 0.2, $fn = 6);
}

bin(100, 40, 3.3);