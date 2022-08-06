module round(r) {
  offset(r = r)
    offset(delta = -r)
      children();
}

e = -10;

module mainSegment(s = [36, 36], notch = [4, 6, 3]) {
  polygon([
    [e, 0], 
    [s[0], 0],
    [s[0], s[1] - 2],
    [0, s[1] - 1],
    [0, s[1] - notch[1]], 
    [notch[0], max(0, s[1] - notch[1] - notch[2])],
    [e, max(0, s[1] - notch[1] - (2 * notch[2]))]
  ]);
}

module dividerSegment(s = [36, 36]) {
  polygon([
    [e / 1.5, 0],
    [s[0], 0],
    [s[0], s[1] / 3],
    [e / 1.5, s[1] / 3]
  ]);
}

module segment(
  s = [36, 36], 
  w = 4, 
  r = 1, 
  dividerThickness = 1,
  notch
) {
  $fn = 32;
  
  mainThickness = w / 2;

  linear_extrude(mainThickness * 2 + dividerThickness)
    round(r)
      dividerSegment(s);
         
  
  linear_extrude(mainThickness)
    round(r)
      mainSegment(s, notch); 
  
  translate([0, 0, mainThickness + dividerThickness])
    linear_extrude(mainThickness) 
      round(r)
        mainSegment(s, notch);
}
//406.4 = 16in
s = [9, 6];
segment = 6;
divider = 2;
$fn = 32;
width = 406 / 2;
slots = width / (segment + divider);
edge = [6, 13];
screwD = 3.3;
screwMinSpace = 50;
screws = floor(width / (screwD + screwMinSpace));
screwSpace = (
    width + 30 - (screws * (screwD + screwMinSpace))
  ) / (screws - 1);

echo(screws, screwSpace);
 
difference() {
  union() {
    for (i = [0 : 1 : slots - 1]) 
      translate([0, 0, (segment + divider) * i])
        segment(
          s, 
          segment,
          .5,
          divider,
          [6, 2, 3]
    );
  }
  
  
  for (i = [0 : 1 : screws - 1])
    translate([
      -screwD + .8, 
      3, 
      ((screwD + screwMinSpace) + screwSpace) * i + screwD + 6
    ])
      rotate([90, 0, 0]) {
        cylinder(h = 4, d = screwD);
      } 
}