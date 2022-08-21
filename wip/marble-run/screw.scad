include<./threads.scad>

height = 3;

difference() {
  translate([-5, -5, 0])
    cube([10, 35, height]);
  
  translate([-5, -10, -1])
    rotate([0, 0, 45])
      cube([5, 10, height + 2]);
  
*  translate([0, 0, -0.1])
    metric_thread(6.02, 1, height + 0.2);   
  
 * translate([0, 8, -0.1])
    metric_thread(6.05, 1, height + 0.2);   
  
  *translate([0, 16, -0.1])
    scale([1.02, 1.02, 1])
      metric_thread(6, 1, height + 0.2);   

  translate([0, 24, -0.1])
    scale([1.05, 1.05, 1]) {
      

      metric_thread(6.05, 1, height + 0.2);   
    }
 
}