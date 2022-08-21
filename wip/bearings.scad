module bearingTrackSlicer(trackRadius, translateX = 14, translateZ = 22.5, $fn = 64) {
   rotate_extrude($fn = $fn)
    translate([translateX, 0, translateZ])
      circle(r = trackRadius, $fn = 8);
}

module bearing(
  outerRadius, 
  innerRadius, 
  outerThickness = 1, 
  innerThickness = 1, 
  outerLipSize = 1, 
  innerLipSize = 1, 
  airGap = 0.2, 
  extraHeight = 0
) {
  calculatedOuterRadius = outerRadius - outerThickness;
  calculatedInnerRadius = innerRadius + innerThickness;
  trackRadius = ((calculatedOuterRadius - calculatedInnerRadius) / 2) - airGap;
  centerRadius = calculatedInnerRadius + airGap + trackRadius;
  height = ceil((trackRadius * 2) + (airGap * 2)) + extraHeight;
  halfTrackSideLength = sin(22.5) * trackRadius;
  br = sqrt((trackRadius * trackRadius) - (halfTrackSideLength * halfTrackSideLength));
  rotationExact = asin((br) / (calculatedInnerRadius + airGap + br));
  rotation = 360 / floor(180 / rotationExact);
  ballCount = 360 / rotation;

  difference() {
    cylinder(r = outerRadius, h = height, center = true, $fn = 64);
    cylinder(r = calculatedOuterRadius - outerLipSize, h = height + 1, center = true, $fn = max(64, ballCount * 2));

    bearingTrackSlicer(trackRadius, centerRadius);
  }

  difference() {
    cylinder(r = calculatedInnerRadius + innerLipSize, h = height, center = true, $fn = max(64, ballCount * 2));
    cylinder(r = innerRadius, h = height + 1, center = true, $fn = 32);

    bearingTrackSlicer(trackRadius, centerRadius, $fn = max(32, ballCount * 2));   
  }

  for (i = [0 : rotation : 360]) {
    rotate([0, 0, i])
      translate([centerRadius, 0, 0])
        sphere(r = br, $fn = 32);
  }
}