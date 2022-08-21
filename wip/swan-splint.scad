include <./scad/util.scad>;

LAYER_HEIGHT = 0.28;

module diamondQuadrulate(pts) {
  if (len(pts) != 2) {
    echo("Not enough points for quadrulate, 2 points needed");
  } else {
    x1 = pts[0].x;
    y1 = pts[0].y;
    x2 = pts[1].x;
    y2 = pts[1].y;
   
    polygon([
      [x1, 0],
      [x2, y2],
      [0, y1],
      [-x2, y2],
      [-x1, 0],
      [-x2, -y2],
      [0, -y1],
      [x2, -y2]
    ]);
  }
}

module triangleQuadrulate(pts) {
  if (len(pts) != 2) {
    echo("Not enough points for quadrulate, 2 points needed");
  } else {
    x1 = pts[0].x;
    y1 = pts[0].y;
    x2 = pts[1].x;
    y2 = pts[1].y;
   
    polygon([
      [30, 30],
      [0, y1],
      [-x1, y2],
      [-x1, 0],
      [-x2, -y2],
      [0, -y1],
      [x2, -y2]
    ]);
  }
}

module splintShape(w = 24, l = 24, r = 5) {
  $fn = 64;
  c = w * PI;
  xInset = 2/5 * w;
  yInset = 1/3 * c;
  
  round(r)
    triangleQuadrulate([
      [w, c],
      [xInset, yInset]
    ]);
}

module splint(w = 24, h = 5, scl = [.6, .95], r = 5) {
  linear_extrude(LAYER_HEIGHT * h)
    difference() {
      splintShape(w, r);

      scale(scl)
        splintShape(w, r);
    }
}

splint(scl = [.6, .9]);