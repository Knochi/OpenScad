railSide = "left"; //["left","right"]
bladeOffset= (railSide=="left") ? 21.5 : 67.2; //left 21.5, right 67.2
woodDims=[44,25];
cutAngle=18.25; //54

#square(180);

//parallelogram
//ha=b*sin(alpha);
//hb=a*sin(beta);

alpha=cutAngle;
ha=woodDims.x;
hb=bladeOffset;
beta=180-alpha;
a=hb/sin(beta);
b=ha/sin(alpha);
bx=b/cos(alpha);

rotate(0)
polygon([[0,0],[a,0],[a+bx,ha],[bx,ha]]);


