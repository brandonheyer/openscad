for(x = [10 : 20 : 180]) {
  linear_extrude(0.2)
    difference() {      
      square([x + 1.6, x + 1.6], center = true);
      square([x, x], center = true);

  }
}
  