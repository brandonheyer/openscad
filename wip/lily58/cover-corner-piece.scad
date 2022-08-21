intersection() {
  import(
    "./originals/lily58-top.stl", 
    convexity = 4
  );
  
  translate([132, 4, -45]) 
    cube([10, 10, 10]);
}