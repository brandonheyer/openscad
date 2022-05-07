
include<gears.scad>;
spiel = 0.1;
Gear_type = 0;

%translate([0,0,-1]) 
  cylinder(1, d = 42);
  

planetengetriebe(
  modul=0.75, 
  zahnzahl_sonne=24, 
  zahnzahl_planet=12, 
  anzahl_planeten=3, 
  breite=5.6, 
  randbreite=2, 
  bohrung=2, 
  eingriffswinkel=5, 
  schraegungswinkel=30, 
  zusammen_gebaut=true, 
  optimiert=false
 );