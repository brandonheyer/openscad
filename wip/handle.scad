stepSize = 0.28;
scalar = 0.5;
zMax = ceil(50 / stepSize) * stepSize;
straightMax = zMax + 30;

echo(zMax);

function scaleMod(i) = i * i * i / 100000;

for (i = [stepSize : stepSize : zMax])
  translate([0, 0, i - stepSize])
    rotate([0, 0, i + 5])
      scale([scalar * (1 + scaleMod(i)), scalar * (1 + scaleMod(i))])
        cylinder(stepSize, d = 20, $fn = 8);

for (i = [zMax : stepSize : straightMax]) {
  translate([0, 0, i - stepSize])
    rotate([0, 0, i + 5])
      scale([scalar * (1 + scaleMod(zMax)), scalar * (1 + scaleMod(zMax))])
        cylinder(stepSize, d = 20, $fn = 8);  
}


//        if (i - stepSize < 20) {
//          difference() {
//            cylinder(stepSize, d = 20, $fn = 8);
//            translate([0, 0, -0.1]) cylinder(20, 1.2, 1.2, $fn = 16);
//          }
//        } else {
//          cylinder(stepSize, d = 20, $fn = 8);
//        }