SIDE = 7;
SMOOTH = 1.2;
SQRT22 = sqrt(2) / 2;
SIDESQ22 = SIDE * SQRT22;
WALL_WIDTH = 1.7;
SIDE2 = 6;
//WW = .452;
WW = 1.4;
SM = .8;

hexaS = SIDE + WALL_WIDTH;
octaS = SIDE + WALL_WIDTH;
octaTY = octaS * sin(135 / 2) + octaS * cos(135 / 2);
hexaTY = (cos(30) * SIDE * 2) + (cos(30) * WALL_WIDTH) + (cos(30) * SMOOTH / 3);

function vx(v) = [v, v];
function vy(v, t) = [ceil(abs(cos(v * 45))), t - floor(abs(cos(v * 45)))];
function zz(x, y) = sin(30) * (x + x - y);

module hexagon(side, offset = 0) {
  s = side - offset;
  
  sx = s * cos(60);
  sy = s * sin(60);
  
  offset(r = offset, $fn = 64)
    polygon([
      [-sx, sy],
      [sx, sy],
      [sx * 2, 0],
      [sx, -sy],
      [-sx, -sy],
      [-sx * 2, 0],
    ]);
}

module hexa(side = SIDE, wallWidth = WALL_WIDTH, smooth = SMOOTH, open = false, slicer = false, outerFudge = 0) {
  if (slicer) {
    hexagon(side, smooth);
  } else {
    difference() {
      hexagon(side + wallWidth + outerFudge, smooth);
      if (open) {
        hexagon(side, smooth);
      }
    }
  }
}

module octagon(side, offset = 0) {
  s = side - offset;
  
  offset(r = offset, $fn = 32)
    union()
      for(i = [0 : 1 : 7]) 
        rotate([0, 0, i * 45])
            polygon([
              [-s * cos(135 / 2), s * sin(135 / 2)], 
              [s * cos(135 / 2), s * sin(135 / 2)],
              [0, 0]
            ]);
    
}

module octa() {
  difference() {
    octagon(SIDE + WALL_WIDTH, SMOOTH);
    octagon(SIDE, SMOOTH);
  }
}

module trio(open = false) {
  rotate([0, 0, 30])
  for(r = [180 : 60 : 300]) {
    rotate([0, 0, r]) translate([0, hexaTY, 0]) hexa(open);
  }
}

module triox(aside = 5, ww = .6, scalar = 0.765) {
  bside = aside + ww / scalar;

  linear_extrude(10) union() {
    translate([cos(30) * -bside, sin(30) * bside, 0]) 
      rotate([0,0,90]) 
        hexa(aside, ww, open = true);
    
    translate([cos(30) *  bside, sin(30) * bside, 0]) 
      rotate([0,0,90]) 
        hexa(aside, ww, open = true);
    
    translate([0, sin(30) * -2 * bside, 0]) 
      rotate([0,0,90])
        hexa(aside, ww, open = true);
  }
}

module hexaLine(side = 6, x = 2, y = 2,  wallWidth = WALL_WIDTH, smooth = SMOOTH, open = true, outerFudge = 0) {
  xs = is_list(x) ? [(x[0] - 1) / 2, (x[1] - 1) / 2] : [0, (x - 1) / 2];
  ys = is_list(y) ? [y[0] - 1, y[1] - 1] : [0, y - 1];
  
  s = side + wallWidth;

  for(y = [ys[0] : 1 : ys[1]]) 
    for(x = [xs[0] : .5 : xs[1]]) {
      sm = (is_list(smooth) && is_list(smooth[y]) && is_num(smooth[y][x * 2 + 1])) ? 
        smooth[y][x * 2 + 1] : is_num(smooth[y]) ? 
          smooth[y] : is_num(smooth) ? 
            smooth : SMOOTH;
  
      sideY = (sin(60) * (s - sm)) + sm;
      sideX = s + sm * .155;
      
      tx = 3 * x * sideX;      
      ty = (((x / .5) % 2 == 0 ? 0 : 1) * sideY) + (
        2 * y * sideY
      );    

      translate([tx, ty])
        hexa(
          side = side, 
          wallWidth = wallWidth, 
          smooth = sm,
          open = open,
          outerFudge = outerFudge
        ); 
    }
}

*linear_extrude(10) hexa(side = 6.5, slicer = true, smooth = 3);
*linear_extrude(10) hexa(side = 7, slicer = true, smooth = 3);
*linear_extrude(10) hexa(side = 7.5, slicer = true, smooth = 3);
*linear_extrude(10) hexa(side = 8, slicer = true, smooth = 3);
*linear_extrude(10) hexa(side = 8.5, slicer = true, smooth = 3);
linear_extrude(10) hexa(side = 9, slicer = true, smooth = 3);

h = 70;
rows = [3, 4, 3];

module hexacomb(rows, side = SIDE2, height = h, wallWidth = WW, smooth = SM, baseHeight = 1.3) {
  count = len(rows) - 1;
  
  translate([0, 0, baseHeight])
    linear_extrude(height - baseHeight)
      union() {
        for (i = [0 : 1 : count]) {
          ry = (i % 2 == 0 && i > 0 && rows[i] > rows[i - 1]) ? [1 - (rows[i] - rows[i - 1]), rows[i] - 1] : [1, rows[i]];

          if (i == 0 || i == count|| rows[i] <= 2) {
            hexaLine(side, [i, i], ry, wallWidth, smooth);
          } else {
            hexaLine(side, [i, i], [ry[0] - 1, ry[0] - 1], wallWidth, smooth);
            hexaLine(side, [i, i], ry, wallWidth, smooth, outerFudge = wallWidth - 0.1);
            hexaLine(side, [i, i], [ry[1] + 1, ry[1] + 1], wallWidth, smooth);
          }
        }
      }
    
  linear_extrude(baseHeight)
    union() {
      for (i = [0 : 1 : count]) {
        ry = (i % 2 == 0 && i > 0 && rows[i] > rows[i - 1]) ? [2 - (rows[i] - rows[i - 1]), rows[i] - 2] : [2, rows[i] - 1];
        
        if (i == 0 || i == count|| rows[i] <= 2) {
          hexaLine(side, [i, i], [ry[0] - 1, ry[1] + 1], wallWidth, smooth, false);
        } else {
          hexaLine(side, [i, i], [ry[0] - 1, ry[0] - 1], wallWidth, smooth, false);
          offset(wallWidth * 2) 
            hexaLine(side, [i, i], ry, wallWidth, smooth, false);
          hexaLine(side, [i, i], [ry[1] + 1, ry[1] + 1], wallWidth, smooth, false);
        }
      }
    }
}

*hexacomb(rows = rows, baseHeight = .9);


*linear_extrude(10) 
  union() {
hexa(5.5, .6, open = true);
translate([0, aa[0], 0]) {
  hexa(6, .6, open = true);
  translate([0, aa[1] - 0.12, 0]) {
    hexa(6.5, .6, open = true);
    translate([0, aa[2] - 0.26, 0]) {
      hexa(7, .6, open = true);
      translate([0, aa[3] - 0.42, 0]) {
      #  hexa(7.5, .6, open = true);
        translate([0, aa[4] - 0.54, 0]) {
          hexa(8, .6, open = true);
          translate([0, aa[5] - 0.66, 0]) {
            hexa(8.5, .6, open = true);
            translate([0, aa[6] - 0.80, 0]) {
              hexa(9, .6, open = true);
              translate([0, aa[7] - 1.4, 0]) {
                hexa(9, .6, open = true);
              }
            }
          }
        }
      }
    }
  }
}
}

// OLD PENCIL HOLDER
*group() {
  linear_extrude(1) {
    rotate([0, 0, 30]) hexa();
    
    for (i = [0 : 1 : 4]) {
      translate([hexaTY * i, 0, 0]) trio();
    }
  }

  translate([0, 0, 1])
    linear_extrude(80) {
      rotate([0, 0, 30]) hexa(true);
      
      for (i = [0 : 1 : 4]) {
        translate([hexaTY * i, 0, 0]) trio(true);
      }
    }
}