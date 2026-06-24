
circularText();
module circularText(txtStrng="IMMIONMI", txtSize=10, txtFont="Liberation Sans:style=Regular", rad=20){
  charAng=16;
  
  charPos=getCharPositions(txtStrng,txtSize,txtFont);
  
  for (i=[0:len(txtStrng)-1]){
    thisAng=atan((charPos[i])/rad*2)*2;
    echo(txtStrng[i],charPos[i],thisAng);
    rotate(-thisAng) translate([0,rad]) text(txtStrng[i],size=txtSize,halign="center", font=txtFont);
  }
}


//get the absolute positions of each char in a string
function getCharPositions(string,size,font="",spacing=1, halign="center",offsets=[],iter=0)=let(
  stringPos=textmetrics(text=string,size=size,font=font, halign=halign, spacing=spacing).position.x,
  thisChrSz=textmetrics(string[iter],size=size,font=font, halign=halign, spacing=spacing).size.x,
  prvChrSz= iter ? textmetrics(string[iter-1],size=size,font=font, halign=halign,spacing=spacing).size.x : 0,
  twoChrsSz=iter ? textmetrics(str(string[iter-1],string[iter]),size=size,font=font, halign=halign,spacing=spacing).size.x : 0,
  charSpcng=twoChrsSz-thisChrSz-prvChrSz,
  charXOffset = (halign=="center") ? (thisChrSz+prvChrSz)/2 : prvChrSz, //TODO: add "right"
  chrOffset= (iter==0) ? stringPos + charXOffset : offsets[iter-1]+charSpcng+charXOffset
) iter<(len(string)) ? getCharPositions(string,size,font,spacing,halign,concat(offsets,chrOffset),iter=iter+1) : offsets;