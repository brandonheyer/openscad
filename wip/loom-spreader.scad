linear_extrude(5)
intersection() {
  circle(r = 22, $fn = 64);
  polygon([
    [0, 0],
    [13.4, 6],
    [13.4, 22],//17.5],
    [-13.4, 22],//17.5],
    [-13.4, 6]
  ]);
}