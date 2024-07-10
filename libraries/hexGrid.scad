/* arrange hexagonal tiles in a grid */

/* [Show] */
debug=true;

/* [Dimensions] */
//outerRadius of the hexagons
hexRad=10;
wallThck=3;

/* [Grid] */
tileCount=[10,5];

/* [Route] */
maxLen=20;
seed=0;

/* [Hidden] */

//hexagon();
//hexGrid(hexRad,wallThck,tileCount);
curSeed=seed ? seed : round(rands(0,100000,3)[0]);
echo("seed",curSeed);
route=rands(0,360,maxLen,round(curSeed));


hexRoute(route=route);
module hexRoute(rad=10,wallThck=3,route=[],coords=[[0,0]],iter=0){
  hexInRad=sqrt(3)/2*rad;
  
  //get direction from route --> 0..5
  dir=floor(route[iter]/60);
  
  //calculate new pos (TODO give alternative if occupied)
  newPos=getNxtPos(hexInRad,dir,coords);
  
  
  if (debug){
    echo("------------");
    echo(iter,"[hexRoute] newPos: ",newPos);
    //Prototype modules to debug
    //getNxtPosDBG(hexInRad,dir,coords);
  }
  
  //place hexagon at new pos
  color("darkRed") translate(newPos){
    hexagon(rad,wallThck);
    if(debug) text(str(iter),size=rad,valign="center",halign="center");
  }
  
  
  
  if (iter==0){
    color("darkgreen") translate(coords[0]){
      hexagon();
      if(debug) text("S",size=rad,valign="center",halign="center");
    }
  }
  if (iter<len(route)-1)
    //next point on the route and add newPos to list
    hexRoute(rad,wallThck,route,concat(coords,[newPos]),iter+1);
  else if (debug){
    echo("------------");
    echo(coords);
    echo("------------");
  }
}

module hexGrid(rad=10,wallThck=3,count=[10,10]){
  hexInRad=sqrt(3)/2*rad;
  hexSiteLen=rad;
  
  xOffset=rad*1.5;
  yOffset=hexInRad;
  
  for (ix=[0:(count.x-1)],iy=[0:(count.y-1)]){
    isEven= ix%2;
    translate([ix*xOffset,iy*yOffset*2+isEven*yOffset]) hexagon(rad,wallThck);
  }
}

*hexagon();
module hexagon(rad=10, wallThck=3){
  //offset to outer radius from wallthickness
  radOffset=(wallThck/cos(30))/2;
  difference(){
    circle(rad+radOffset,$fn=6);
    circle(rad-radOffset,$fn=6);
  }
}

// -- Debug Modules --
//module Prototype to debug
module getNxtPosDBG(rad,dir,coords,iter=5){
  pos=coords[len(coords)-1];
  xOffset=rad*2 * cos(dir*60+30);
  yOffset=rad*2 * sin(dir*60+30);
  newPos= pos + [xOffset,yOffset];

  isDouble=findDoubles(coords,newPos);
  nxtDir=wrapAround(0,5,dir+iter);
  
  findDoublesDBG(coords,newPos);
  
  if (isDouble && iter){
    echo(str("[NPosDbg]Double!", newPos));
    echo(str(" Trying ",nxtDir * 60 + 30,"° vs. ", dir * 60 +30, "°"));
    getNxtPosDBG(rad,nxtDir,coords,iter-1);
  }
  else
    echo(str("[NPosDbg]Giving: ",newPos));
}

module findDoublesDBG(coords,pos,iter=0){
  echo(str("[fDblDbg] calling degrade with: ",coords[iter]));
  if (degrade2D(coords[iter]) == degrade2D(pos))
    echo("  Hit");
  else if (iter<len(coords)-1)
    findDoublesDBG(coords,pos,iter+1);
  else
    echo("  finish");
}

// -- Helper functions --

//returns a new pos if already used or current pos if not used
function getNxtPos(rad,dir,coords,iter=5)=let(
  pos=coords[len(coords)-1],
  xOffset=rad*2 * cos(dir*60+30),
  yOffset=rad*2 * sin(dir*60+30),
  newPos= pos + [xOffset,yOffset],
  isDouble=findDoubles(coords,newPos),
  nxtDir=wrapAround(0,5,dir+iter)
  ) 
  (isDouble && iter) ? getNxtPos(rad,nxtDir,coords,iter-1) : 
  newPos;
 

  

//return index if pos is found, else return "false"
function findDoubles(coords,pos,iter=0)= let(
  degCoords=degrade2D(coords[iter]),
  degPos=degrade2D(pos)
  ) 
    (degCoords == degPos) ? 
    iter : iter<len(coords)-1  ? findDoubles(coords,pos,iter+1) : false;



function degrade(value,digits=4)=floor(value * pow(10,digits))/pow(10,digits);
function degrade2D(vector,digits=3)=[degrade(vector[0],digits),degrade(vector[1],digits)];


function wrapAround(min,max,value)=
            value < min ? max-min+value : 
            value > max ? min + (value - max -1) : value;


