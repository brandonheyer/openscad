use <./threads.scad>;

NPT_TAPER = 1/16;
NPT_LOOKUP = [
  // 3/4"
  [1.050, 14.0, 3/4],
  
  // 1"
  [1.315, 11.5, 7/8]
];

module makeNpt(sizes = NPT_LOOKUP[0], internal = false, test = $preview, extraLength = 0) {
  diameter = sizes[0];
  tpi = sizes[1];
  length = sizes[2] + extraLength;
  
  english_thread(
    diameter = diameter, 
    threads_per_inch = tpi, 
    length = length, 
    taper = NPT_TAPER, 
    internal = false,
    test = test
  );
}

module npt(size = 0.75, internal = false, test = $preview, extraLength = 0) {
  if (size == 0.75) {
    makeNpt(NPT_LOOKUP[0], internal, test, extraLength);
  } else if (size == 1) {
    makeNpt(NPT_LOOKUP[1], internal, test, extraLength);    
  }
}

/**
Pipe Size
(inches)	TPI	Approximate Length of Thread (inches)	Approximate Number of Threads to be Cut	Approximate Total thread Makeup, Hand and Wrench (inches)	Nominal Outside Diameter Pipe
OD
(inches)
Tap Drill
(inches)
1/16"	27				0.313	 
1/8"	27	3/8	10	1/4	0.405	R
1/4"	18	5/8	11	3/8	0.540	7/16
3/8"	18	5/8	11	3/8	0.675	37/64
1/2"	14	3/4	10	7/16	0.840	23/32
3/4"	14	3/4	10	1/2	1.050	59/64
1"	11-1/2	7/8	10	9/16	1.315	1-5/32
1-1/4"	11-1/2	1	11	9/16	1.660	1-1/2
1-1/2"	11-1/2	1	11	9/16	1.900	1-47/64
2"	11-1/2	1	11	5/8	2.375	2-7/32
2-1/2"	8	1 1/2	12	7/8	2.875	2-5/8
3"	8	1 1/2	12	1	3.500	3-1/4
3-1/2"	8	1 5/8	13	1 1/16	4.000	3-3/4
4"	8	1 5/8	13	1 1/16	4.500	4-1/4
4 1/2"	8				5.000	4-3/4
5"	8	1 3/4	14	1 3/16	5.563	5-9/32
6"	8	1 3/4	14	1 3/16	6.625	6-11/32
8"	8	1 7/8	15	1 5/16	8.625	  
*/