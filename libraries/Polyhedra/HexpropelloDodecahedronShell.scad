// http://dmccooey.com/polyhedra/DualGeodesicIcosahedron3.html



/* [show] */
quality=50; //[20:100]
showPentaTile=true;
showHexTile=true;
showSurface=false;

/* [Select] */
pentaFaceIdx=60; //[60:71]
hexFaceIdx=0; //[0:59]

/* [Debug] */
dbgVerts=false;
dbgOrig=false;
dbgStats=false;

/* [Dimensions] */
//incircle radius of faces touch this 
outerDia=60;
innerDia=50;

/* [Hidden] */
$fn=quality;
fudge=0.1;


phi = (1 + sqrt(5)) / 2;
x = cbrt((phi + sqrt(phi-5/27))/2) + cbrt((phi - sqrt(phi-5/27))/2);

//Coordinates
C0  = (-(x^2) * (321 + 8*phi) + x * (149*phi - 4) + 4 * (153 - 4*phi)) / 209;
C1  = ((x^2) * (149*phi - 4) - 2 * x * (15 + 16*phi) - (8 + 329*phi)) / 209;
C2  = phi * (3 - (x^2));
C3  = phi * (2 * x - phi - 3 / x);
C4  = (-12*(x^2) * (1 + 15*phi) + x*(119 + 113*phi) + 3*(89*phi - 8)) / 209;
C5  = (1 + phi - x) / (x^3);
C6  = (3 * x * (29*phi - 12) - (61 + 79*phi) + (137 - 35*phi) / x) / 209;
C7  = (x * (117 + 83 * phi) - (63 + 109 * phi) - (184 + 43 * phi) / x) / 209;
C8  = x * phi * (x - phi);
C9  = ((x^2) * (59*phi - 10) - 5*x * (15 + 16*phi) + 2*(59*phi - 10)) / 209;
C10 = (phi^2) * (x - 1 - 1 / x);
C11 = 1 / (x * phi);
C12 = phi * (1 - 1 / x) / x;
C13 = (2*(x^2) * (104*phi - 7) - 7*x*(15 + 16*phi) - (28 + 211*phi)) / 209;
C14 = (phi^3) / (x^2) - 1;
C15 = phi * (1 / (x^2) + phi / x - 1);
C16 = (x * (4 + 3 * phi) + (13 * phi - 8) - (11 + 13 * phi) / x) / 19;
C17 = phi * (phi - phi / x - 1 / (x^2));
C18 = 1 / x;
C19 = 1 - phi / x + phi / (x^2);
C20 = (-x * (29*phi - 12) + (96*phi - 119) + (24 + 151*phi) / x) / 209;
C21 = (8 * x * (1 + 15*phi) + (64*phi - 149) - 2 * (89*phi - 8) / x) / 209;
C22 = phi * (1 - phi / (x^2));
C23 = (-4 * x * (29 + 17*phi) + (175 + 117*phi) + (186 + 73*phi) / x) / 209;
C24 = (-x * (72*phi - 37) + (173 + 87*phi) + 5 * (13*phi - 27) / x) / 209;
C25 = phi * (phi - x + 1 / x);
C26 = x * phi + 1 - (x^2);
C27 = (-x * (104*phi - 7) + (157 + 56*phi) + 14 * (1 + 15*phi) / x) / 209;
C28 = (phi / x)^2;
C29 = (3 * x * (1 + 15*phi) + (127 + 24*phi) - (119*phi - 6) / x) / 209;
C30 = phi / x;
C31 = (2 * (x^2) * (14 + phi) + x * (1 + 15 * phi) + 4 * (14 + phi)) / 209;

//verts
V=[[  C2,   C3,  1.0],
   [  C2,  -C3, -1.0],
   [ -C2,  -C3,  1.0],
   [ -C2,   C3, -1.0],
   [ 1.0,   C2,   C3],
   [ 1.0,  -C2,  -C3],
   [-1.0,  -C2,   C3],
   [-1.0,   C2,  -C3],
   [  C3,  1.0,   C2],
   [  C3, -1.0,  -C2],
   [ -C3, -1.0,   C2],
   [ -C3,  1.0,  -C2],
   [  C9,   C0,  C31],
   [  C9,  -C0, -C31],
   [ -C9,  -C0,  C31],
   [ -C9,   C0, -C31],
   [ C31,   C9,   C0],
   [ C31,  -C9,  -C0],
   [-C31,  -C9,   C0],
   [-C31,   C9,  -C0],
   [  C0,  C31,   C9],
   [  C0, -C31,  -C9],
   [ -C0, -C31,   C9],
   [ -C0,  C31,  -C9],
   [ 0.0,  C11,  C30],
   [ 0.0,  C11, -C30],
   [ 0.0, -C11,  C30],
   [ 0.0, -C11, -C30],
   [ C30,  0.0,  C11],
   [ C30,  0.0, -C11],
   [-C30,  0.0,  C11],
   [-C30,  0.0, -C11],
   [ C11,  C30,  0.0],
   [ C11, -C30,  0.0],
   [-C11,  C30,  0.0],
   [-C11, -C30,  0.0],
   [ C13,  -C6,  C29],
   [ C13,   C6, -C29],
   [-C13,   C6,  C29],
   [-C13,  -C6, -C29],
   [ C29, -C13,   C6],
   [ C29,  C13,  -C6],
   [-C29,  C13,   C6],
   [-C29, -C13,  -C6],
   [  C6, -C29,  C13],
   [  C6,  C29, -C13],
   [ -C6,  C29,  C13],
   [ -C6, -C29, -C13],
   [  C8, -C12,  C28],
   [  C8,  C12, -C28],
   [ -C8,  C12,  C28],
   [ -C8, -C12, -C28],
   [ C28,  -C8,  C12],
   [ C28,   C8, -C12],
   [-C28,   C8,  C12],
   [-C28,  -C8, -C12],
   [ C12, -C28,   C8],
   [ C12,  C28,  -C8],
   [-C12,  C28,   C8],
   [-C12, -C28,  -C8],
   [ C16,   C7,  C27],
   [ C16,  -C7, -C27],
   [-C16,  -C7,  C27],
   [-C16,   C7, -C27],
   [ C27,  C16,   C7],
   [ C27, -C16,  -C7],
   [-C27, -C16,   C7],
   [-C27,  C16,  -C7],
   [  C7,  C27,  C16],
   [  C7, -C27, -C16],
   [ -C7, -C27,  C16],
   [ -C7,  C27, -C16],
   [  C5,  C17,  C26],
   [  C5, -C17, -C26],
   [ -C5, -C17,  C26],
   [ -C5,  C17, -C26],
   [ C26,   C5,  C17],
   [ C26,  -C5, -C17],
   [-C26,  -C5,  C17],
   [-C26,   C5, -C17],
   [ C17,  C26,   C5],
   [ C17, -C26,  -C5],
   [-C17, -C26,   C5],
   [-C17,  C26,  -C5],
   [ C14,  C15,  C25],
   [ C14, -C15, -C25],
   [-C14, -C15,  C25],
   [-C14,  C15, -C25],
   [ C25,  C14,  C15],
   [ C25, -C14, -C15],
   [-C25, -C14,  C15],
   [-C25,  C14, -C15],
   [ C15,  C25,  C14],
   [ C15, -C25, -C14],
   [-C15, -C25,  C14],
   [-C15,  C25, -C14],
   [ C20,  -C4,  C24],
   [ C20,   C4, -C24],
   [-C20,   C4,  C24],
   [-C20,  -C4, -C24],
   [ C24, -C20,   C4],
   [ C24,  C20,  -C4],
   [-C24,  C20,   C4],
   [-C24, -C20,  -C4],
   [  C4, -C24,  C20],
   [  C4,  C24, -C20],
   [ -C4,  C24,  C20],
   [ -C4, -C24, -C20],
   [ C21,   C1,  C23],
   [ C21,  -C1, -C23],
   [-C21,  -C1,  C23],
   [-C21,   C1, -C23],
   [ C23,  C21,   C1],
   [ C23, -C21,  -C1],
   [-C23, -C21,   C1],
   [-C23,  C21,  -C1],
   [  C1,  C23,  C21],
   [  C1, -C23, -C21],
   [ -C1, -C23,  C21],
   [ -C1,  C23, -C21],
   [ C10, -C19,  C22],
   [ C10,  C19, -C22],
   [-C10,  C19,  C22],
   [-C10, -C19, -C22],
   [ C22, -C10,  C19],
   [ C22,  C10, -C19],
   [-C22,  C10,  C19],
   [-C22, -C10, -C19],
   [ C19, -C22,  C10],
   [ C19,  C22, -C10],
   [-C19,  C22,  C10],
   [-C19, -C22, -C10],
   [ C18,  C18,  C18],
   [ C18,  C18, -C18],
   [ C18, -C18,  C18],
   [ C18, -C18, -C18],
   [-C18,  C18,  C18],
   [-C18,  C18, -C18],
   [-C18, -C18,  C18],
   [-C18, -C18, -C18]];

//Faces
F=[[  24,   0,  12,  60,  84,  72 ], //hexagons
   [  24,  72, 116, 106, 122,  50 ],
   [  24,  50,  38,  14,   2,   0 ],
   [  25,   3,  15,  63,  87,  75 ],
   [  25,  75, 119, 105, 121,  49 ],
   [  25,  49,  37,  13,   1,   3 ],
   [  26,   2,  14,  62,  86,  74 ],
   [  26,  74, 118, 104, 120,  48 ],
   [  26,  48,  36,  12,   0,   2 ],
   [  27,   1,  13,  61,  85,  73 ],
   [  27,  73, 117, 107, 123,  51 ],
   [  27,  51,  39,  15,   3,   1 ],
   [  28,   4,  16,  64,  88,  76 ],
   [  28,  76, 108,  96, 124,  52 ],
   [  28,  52,  40,  17,   5,   4 ],
   [  29,   5,  17,  65,  89,  77 ],
   [  29,  77, 109,  97, 125,  53 ],
   [  29,  53,  41,  16,   4,   5 ],
   [  30,   6,  18,  66,  90,  78 ],
   [  30,  78, 110,  98, 126,  54 ],
   [  30,  54,  42,  19,   7,   6 ],
   [  31,   7,  19,  67,  91,  79 ],
   [  31,  79, 111,  99, 127,  55 ],
   [  31,  55,  43,  18,   6,   7 ],
   [  32,   8,  20,  68,  92,  80 ],
   [  32,  80, 112, 101, 129,  57 ],
   [  32,  57,  45,  23,  11,   8 ],
   [  33,   9,  21,  69,  93,  81 ],
   [  33,  81, 113, 100, 128,  56 ],
   [  33,  56,  44,  22,  10,   9 ],
   [  34,  11,  23,  71,  95,  83 ],
   [  34,  83, 115, 102, 130,  58 ],
   [  34,  58,  46,  20,   8,  11 ],
   [  35,  10,  22,  70,  94,  82 ],
   [  35,  82, 114, 103, 131,  59 ],
   [  35,  59,  47,  21,   9,  10 ],
   [ 132,  84,  60, 108,  76,  88 ],
   [ 132,  88,  64, 112,  80,  92 ],
   [ 132,  92,  68, 116,  72,  84 ],
   [ 133, 121, 105,  45,  57, 129 ],
   [ 133, 129, 101,  41,  53, 125 ],
   [ 133, 125,  97,  37,  49, 121 ],
   [ 134, 120, 104,  44,  56, 128 ],
   [ 134, 128, 100,  40,  52, 124 ],
   [ 134, 124,  96,  36,  48, 120 ],
   [ 135,  85,  61, 109,  77,  89 ],
   [ 135,  89,  65, 113,  81,  93 ],
   [ 135,  93,  69, 117,  73,  85 ],
   [ 136, 122, 106,  46,  58, 130 ],
   [ 136, 130, 102,  42,  54, 126 ],
   [ 136, 126,  98,  38,  50, 122 ],
   [ 137,  87,  63, 111,  79,  91 ],
   [ 137,  91,  67, 115,  83,  95 ],
   [ 137,  95,  71, 119,  75,  87 ],
   [ 138,  86,  62, 110,  78,  90 ],
   [ 138,  90,  66, 114,  82,  94 ],
   [ 138,  94,  70, 118,  74,  86 ],
   [ 139, 123, 107,  47,  59, 131 ],
   [ 139, 131, 103,  43,  55, 127 ],
   [ 139, 127,  99,  39,  51, 123 ],
   [  12,  36,  96, 108,  60 ], //60 - pentagons
   [  13,  37,  97, 109,  61 ],
   [  14,  38,  98, 110,  62 ],
   [  15,  39,  99, 111,  63 ],
   [  16,  41, 101, 112,  64 ],
   [  17,  40, 100, 113,  65 ],
   [  18,  43, 103, 114,  66 ],
   [  19,  42, 102, 115,  67 ],
   [  20,  46, 106, 116,  68 ],
   [  21,  47, 107, 117,  69 ],
   [  22,  44, 104, 118,  70 ],
   [  23,  45, 105, 119,  71 ]]; //71

hexTileHght= norm(
          centroid([for (vert=F[hexFaceIdx]) V[vert]*outerDia/2])-
          centroid([for (vert=F[hexFaceIdx]) V[vert]*innerDia/2])
            );
          
pentaTileHght= norm(
          centroid([for (vert=F[pentaFaceIdx]) V[vert]*outerDia/2])-
          centroid([for (vert=F[pentaFaceIdx]) V[vert]*innerDia/2])
            );

          
if (showSurface){
  scale(outerDia/2) polyhedron(V,F);
  %sphere(d=outerDia);
}

if (showPentaTile)
  pentagonTile(pentaFaceIdx);

if (showHexTile){

  difference(){
    hexagonTile(hexFaceIdx);
    translate([0,0,hexTileHght/2]){
      sphere(2.9);
      cylinder(d=5.2,h=5);
    }
    translate([0,0,-fudge]) cylinder(d=4,h=5);
  }

}

module pentagonTile(inputFace=60){
  //do one pentaGon as a tile
  //get the verts from one pentagon
  vertsInner= [for (vert=F[inputFace]) V[vert]*innerDia/2];
  vertsOuter= [for (vert=F[inputFace]) V[vert]*outerDia/2];
  verts=concat(vertsInner,vertsOuter);
  echo(verts);
  faces= [[0,1,2,3,4],
          [0,4,9,5],
          [4,3,8,9],
          [3,2,7,8],
          [1,2,7,6],
          [0,1,6,5],
          [5,6,7,8,9]];
  
  for (i=[0:len(vertsOuter)-1])
    translate(vertsOuter[i]) indexSphere(outerDia/100,str(i),"red");
  for (i=[0:len(vertsInner)-1])
    translate(vertsInner[i]) indexSphere(outerDia/100,str(i+5),"green");
  
  layFlat(vertsInner) polyhedron(verts,faces);
}

*hexagonTile(hexFaceIdx);
module hexagonTile(inputFace=0){
  //do one pentaGon as a tile
  //get the verts from one pentagon
  vertsInner= [for (vert=F[inputFace]) V[vert]*innerDia/2];
  vertsOuter= [for (vert=F[inputFace]) V[vert]*outerDia/2];
  verts=concat(vertsInner,vertsOuter);
  
  faces= [[0,1,2,3,4,5], //inner
          [0,5,11,6],
          [5,4,10,11],
          [4,3,9,10],
          [3,2,8,9],
          [2,1,7,8],
          [1,0,6,7],
          [11,10,9,8,7,6]]; //outer
  
  if (dbgVerts){
    for (i=[0:len(vertsInner)-1])
      translate(vertsInner[i]) indexSphere(outerDia/100,str(i),"red");
    for (i=[0:len(vertsOuter)-1])
      translate(vertsOuter[i]) indexSphere(outerDia/100,str(i+6),"green");
  }
  
  if (dbgOrig)
    %polyhedron(verts,faces);
  
  if (dbgStats){
    eLen= [for (i=[0:5]) norm(vertsInner[i]-vertsOuter[i])];
    inVertsRad= [for (i=[0:5]) norm(centroid(vertsInner)-vertsInner[i])];
    outVertsRad= [for (i=[0:5]) norm(centroid(vertsOuter)-vertsOuter[i])];
    outInVertsRad= [for (i=[0:5]) outVertsRad[i]-inVertsRad[i]];
    eAngles=[for (i=[0:5]) asin(outInVertsRad[i]/eLen[i])];
    eHeights=[for (i=[0:5]) sqrt(eLen[i]^2-outInVertsRad[i]^2)];
    echo(str("Edge Lengths:",eLen));
    echo(str("innerVerts radii:",inVertsRad));
    echo(str("outerVerts radii:",outVertsRad));
    echo(str("outer- innerVerts radii:",outInVertsRad));
    echo(str("Edge Angles:",eAngles));
    echo(str("Edge Heights:",eHeights));
    
  }
  
  layFlat(vertsInner) polyhedron(verts,faces,convexity=5);;
  
}

module indexSphere(dia=1,txt="1",col="blue"){
  difference(){
    color(col) sphere(d=dia);
    for (m=[0,1])
    rotate([m*180,0,0]) translate([0,0,dia/2-dia/5]) linear_extrude(dia/5) 
      text(text=txt,size=dia/2,valign="center",halign="center");
  }
}

//provides translation and rotation to lay a children flat on the ground
module layFlat(vertices,vertsIdx=[0,1,2]){
  
  //calculate normal
  vec1=vertices[vertsIdx[1]]-vertices[vertsIdx[0]];
  vec2=vertices[vertsIdx[2]]-vertices[vertsIdx[0]];
  v=cross(vec1,vec2);
  
  //longitude
  phi=atan2(v.y,v.x);
  //lattidute
  theta=acos(v.z/norm(v));
  //centroid
  centroid=centroid(vertices);
  
  rotate([0,-theta,0]) 
    rotate([0,0,-phi])
      translate(-centroid)
        children();
}

//cube root
function cbrt(x)=pow(x,1/3);

function centroid(verts,sum=[0,0,0],iter=0)=
  iter<len(verts) ? centroid(verts,sum+verts[iter]/len(verts),iter+1) : sum;
