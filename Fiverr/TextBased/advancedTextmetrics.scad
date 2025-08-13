// Character positioning test


string="IXHHAVVAA";
txtSize=13;
txtFont="";
charSel=4;

tm=textmetrics(string,txtSize,txtFont);
echo(tm);

text(string,txtSize,txtFont);
color("red") translate([tm.position.x,-1,0]) cube([tm.size.x,1,0.5]);

tm2=textmetrics(str(string[charSel],string[charSel+1]),txtSize,txtFont);

charTmThis=textmetrics(string[charSel],txtSize,txtFont);
charTmNext=textmetrics(string[charSel+1],txtSize,txtFont);

//charSpcng=2.072;
charSpcng=tm2.size.x-charTmThis.size.x-charTmNext.size.x;
echo(charSpcng);
translate([0,tm.size.y*2,0]){
 text(str(string[charSel],string[charSel+1]),txtSize,txtFont);
 color("red") translate([tm2.position.x,-1,0]) cube([charTmThis.size.x,1,0.5]);
 color("red") translate([tm2.position.x+charTmThis.size.x+charSpcng,-1,0]) cube([charTmNext.size.x,1,0.5]);
 color("blue")translate([tm2.position.x+charTmThis.size.x,-1,0]) cube([abs(charSpcng),1,0.75]);
 color("green") translate([tm2.position.x,-1,-0.5]) cube([tm2.size.x,1,0.5]);
}



echo(tm2);
echo("Offsets:",getCharOffsets(string,txtSize,txtFont));

!echo(getCharSpacings("AVAVAVA",11));
function getCharSpacings(string,size,font="",spacing=1,spcngs=[],iter=0)=let(
  stringPos=textmetrics(text=string,size=size,font=font,spacing=spacing).position.x,
  thisChrSz=textmetrics(string[iter],size=size,font=font,spacing=spacing).size.x,
  prvChrSz= iter ? textmetrics(string[iter-1],size=size,font=font,spacing=spacing).size.x : 0,
  twoChrsSz=iter ? textmetrics(str(string[iter-1],string[iter]),size=size,font=font,spacing=spacing).size.x : 0,
  chrSpcng= (iter==0) ? stringPos : twoChrsSz-thisChrSz-prvChrSz
) iter<(len(string)) ? getCharSpacings(string,size,font,spacing,concat(spcngs,chrSpcng),iter=iter+1) : spcngs;

function getCharOffsets(string,size,font="",spacing=1,offsets=[],iter=0)=let(
  stringPos=textmetrics(text=string,size=size,font=font,spacing=spacing).position.x,
  thisChrSz=textmetrics(string[iter],size=size,font=font,spacing=spacing).size.x,
  prvChrSz= iter ? textmetrics(string[iter-1],size=size,font=font,spacing=spacing).size.x : 0,
  twoChrsSz=iter ? textmetrics(str(string[iter-1],string[iter]),size=size,font=font,spacing=spacing).size.x : 0,
  chrOffset= (iter==0) ? stringPos : offsets[iter-1]+twoChrsSz-thisChrSz-prvChrSz
) iter<(len(string)) ? getCharSpacings(string,size,font,spacing,concat(offsets,chrOffset),iter=iter+1) : spcngs;