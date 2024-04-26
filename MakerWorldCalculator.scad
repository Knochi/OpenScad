pointsPerDownload=[[30,10,0],[25,25,50]]; //Points,perDownloads,Threshold

/* [show] */
showOutput="points"; //["points","cash"]

/* [Points from downloads] */
//1st Tier Points..
ppd1stTierPnts=30; 
//..per Downloads..
ppd1stTierDowns=10;
//..from Download No
ppd1stTierThres=0;

//2nd Tier Points..
ppd2ndTierPnts=25;
//..per Downloads..
ppd2ndTierThres=51;
//..from Download No
ppd2ndTierDowns=25;

downloads=10000;

/* [Cash from Points] */
cashCurrency = "EUR";
//value of one gift card
cashCardVal = 40;
//Points to spend for one card
cashPointsPerCard= 524;
cashTarget=1000;

pointsArray=[for (i=[0:downloads]) pointsFromDownloads(i)];
cashArray=[for (i=[0:downloads]) cashFromPoints(pointsFromDownloads(i))];

echo(str("Revenue: ",cashFromPoints(pointsFromDownloads(downloads))," ",cashCurrency));


if (showOutput=="points")
  polygon(graphFromArray(pointsArray));
else
  polygon(graphFromArray(cashArray));


function graphFromArray(array,unitScale=[1,1],poly=[[0,0]],iter=0)=let(
  y=iter<len(array) ? array[iter]*unitScale.y : 0,
  x=iter*unitScale.x
) iter<len(array) ? graphFromArray(array,unitScale,concat(poly,[[x,y]]),iter+1) : concat(poly,[[poly[iter].x,0]]);

function pointsFromDownloads(downloads)=let(
  firstTier= (downloads>=ppd2ndTierThres) ? ppd1stTierPnts * (ppd2ndTierThres-1)/ppd1stTierDowns :
                                            ppd1stTierPnts * floor(downloads/ppd1stTierDowns) ,
  secondTier= (downloads>=ppd2ndTierThres) ? ppd2ndTierPnts * floor((downloads - ppd2ndTierThres+1)/ppd2ndTierDowns) : 0
) firstTier+secondTier;

function cashFromPoints(points)=cashCardVal*floor(points/cashPointsPerCard);