/* [Dimensions] */
ovDims=[56.5,46.5,33.75];
    //   0         1         2       3     4     5     6         7         8
heights=[0       , 3.85,     10.75,  16,   40,   40,   ovDims.y, ovDims.y, 42.4];
widths= [ovDims.x, ovDims.x, 18.3,   14.7, 33.5, 50.5, 46.65,    27,       23.8        ]; //from top to bottom
bdyThck=3;
gap=0.5;
hingeThck=0.2;

/* [FinDimensions] */
finThck=1.5;


/* [Hidden] */
//body shape
bdyPoly=[for (i=[0:len(heights)-1]) [widths[i]/2,heights[i]],
      for (i=[1:len(heights)]) [-widths[len(heights)-i]/2,heights[len(heights)-i]]
      ];
      
//the side where the fins are attached
sideLen=norm([widths[4]/2,heights[4]]-[widths[3]/2,heights[3]]);
sideAng=atan2((widths[4]-widths[3])/2,heights[4]-heights[3]);


//fins
finAng=atan2((widths[4]-widths[7])/2,heights[7]-heights[4]); //tan(alpha)=x/y
finWdth=sqrt(pow((widths[4]-widths[7])/2,2)+pow(heights[7]-heights[4],2));
finPos=[[widths[4]/2,heights[4],0],
        [widths[3]/2+sideLen/2*cos(90-sideAng),heights[3]+sideLen/2*sin(90-sideAng)],
        [widths[3]/2,heights[3]]];
        

finPoly=[];
  

for (im=[0,1])
  mirror([0,im]) translate([0,gap/2,0])
    linear_extrude(bdyThck/2) polygon(bdyPoly);

//front fins (same length)
#for (pos=finPos)
  translate(pos+[0,+gap/2,0]) rotate(finAng)  linear_extrude(3) translate([finThck/2,finWdth/2]) square([finThck,finWdth],true);

module fins(){
    
}
 
 