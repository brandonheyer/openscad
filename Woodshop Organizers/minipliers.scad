use <./hook.scad>;

module case(xs, ys, h = 16, spacing = 4, c = 6) {
  linear_extrude(h * c + spacing * (c + 1))
    polygon([
      [xs[0], ys[0]],
      [xs[1], ys[0]],
      [xs[1], ys[1]],
      [xs[2], ys[2]],
      [xs[0], ys[2]],
      [-xs[3], ys[2]],
      [-xs[3], ys[1]], 
      [-xs[3], ys[0]]
    ]);
}

module slot(xs, ys, h = 16) {
  linear_extrude(h)
    polygon([
      [xs[0], ys[0]],
      [xs[1], ys[0]],
      [xs[1], ys[1]],
      [xs[2], ys[2]],
      [xs[0], ys[2]],
      [-xs[2], ys[2]],
      [-xs[1], ys[1]], 
      [-xs[1], ys[0]]
    ]);
}

module plierMountSlicer(t) {
  translate(t)
    rotate([0, 0, 90])
      scale(1.1) 
        fullMountSlicer([46, 6.75, 6]);
}



//  Craftsman
//
//c = 6;
//space = 4;
//cty = -1; 
//ctz = -4;
//h = 16;
//casexs = [0, 19.4, 26.4, 32.4];
//caseys = [0.1, 19.9, 48.9];
//xs = [0, 17, 24];
//ys = [-3, 20, 50];
//tx = -5;
//pegGap = 77;

// Micro
//c = 6;
//tx = -2;
//xs = [0, 8, 16];
//ys = [0, 12, 36];
//casexs = [0, 10.4, 18.4, 22.4];
//caseys = [4.2, 11.9, 35.9];
//h = 9.4;
//cty = -2; 
//ctz = -2;
//space = 2;
//pegGap = 52;
//pegX = -15.5;

// Linesman
//pegOffset = 5;
//c = 5;
//tx = -3.8;
//xs = [0, 19.6, 19.6];
//ys = [0, 20, 40];
//casexs = [0, 22, 22, 34];
//caseys = [4.2, 20, 40];
//h = 15.4;
//cty = -2; 
//ctz = -5;
//space = 5;
//pegGap = 77;
//pegX = -26.8;

group() {
  pegO = 6;
  pliers(
    [0, 15.4, 18],
    [0, 16, 36], 
    1,
    18.4,
    3,
    [pegO], 
    -20.2, 
    7, 
    -2.8
  );
  
  translate([0, 0, 21.4])
    pliers(
      [0, 11, 18],
      [0, 16, 36], 
      1,
      10,
      3,
      [], 
      -20.2, 
      7, 
      -2.8
    );
  
  translate([0, 0, 34.4])
    pliers(
      [0, 9.6, 18],
      [0, 16, 36], 
      3,
      10,
      2.4,
      [-34.4 + pegO + (25.4 * 2)], 
      -20.2, 
      7, 
      -2.8
    );   
}

*pliers(
  [0, 7, 18],
  [0, 16, 36], 
  4,
  8.2,
  2,
  [-2 + 30.6, -2 + 30.6 - 25.4], 
  -16.8, 
  3.6, 
  -2.4
);

*group() { 
  pliers(
    [0, 26, 26],
    [-3, 16, 40], 
    1,
    20,
    5,
    [0], 
    -36, 
    15, 
    -5
  );
  
  translate([-7, 0, 44]) 
    pliers(
      [0, 21, 21],
      [-3, 5, 40], 
      1,
      14,
      5,
      [-44 + 25.4 + 25.4], 
      -29, 
      13, 
      -5
    );
 
  translate([-2, 0, 25]) 
    pliers(
      [0, 16, 25],
      [-3, 5, 40], 
      1,
      14,
      5,
      [], 
      -20.8, 
      14, 
      -5
    );
}

module pliers(
  xs, 
  ys,
  c, 
  h, 
  space,
  pegs,
  pegOffset = 2,
  backOffset = 0,
  slotT = 0,
  caseTZ = -2, 
  caseY1 = 4.2
) {
  casexs = [
    0, 
    xs[1] + 2.4,
    xs[2] + 2.4, 
    xs[2] + 2.4 + backOffset
  ];
  
  caseys = [
    caseY1, 
    ys[1], 
    ys[2]
  ];
  
  tx = slotT;
  cty = caseTZ; 
  ctz = -space;
  
  difference() { 
    translate([0, cty, ctz])
      case(casexs, caseys, h, space, c);

    for (i = [0 : 1 : c - 1])
      rotate([0, 0, -5]) 
        translate([tx, 0, i * (h + space)])
          slot(xs, ys, h);
    
    for (p = pegs)
      #plierMountSlicer([pegOffset, -8, p]);
  }
}