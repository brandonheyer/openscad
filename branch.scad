SEED = rands(0, 100, 1)[0];
START_SIZE = 20;
START_HEIGHT = 90;

module childBranch(maxDepth = 3, seed, depth = 0, child = 1) {
  angle = 4 * (seed == -1 ?
    floor(rands(-12, 12, 1)[0]) : 
    floor(rands(-12, 12, 1, seed + child + 1)[0])
  );
  
  height = SEED == -1 ?
    floor(rands(4, 12, 1)[0]) * 2 :
    floor(rands(8, 24, 1, seed + child + 2)[0]);

  slide = SEED == -1 ?
    floor(rands(18, 24, 1)[0]) :
    floor(rands(18, 24, 1, seed + 3)[0]);

  rotate([0, angle, 0]) {
    cylinder(START_HEIGHT + height, START_SIZE - depth, START_SIZE - depth - 1);
   
    if (depth < maxDepth) {
      translate([0, 0, START_HEIGHT - height])
        branch(maxDepth, seed, depth + 1, child);
    }
  }
}

//BRANCH_COUNTS = [2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2];
BRANCH_COUNTS = [0,0,0,1,1,2];

module branch(maxDepth = 3, seed, depth = 0, child = 1) {
  children = floor(rands(0, len(BRANCH_COUNTS), 1, seed + 10)[0]);
  
  for (i = [0 : 1 : BRANCH_COUNTS[children]]) {
    childBranch(maxDepth, seed, depth, i);
  }
}


branch(2, SEED);