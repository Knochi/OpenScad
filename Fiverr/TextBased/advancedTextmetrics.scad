// Character positioning test


string="IXHHAVVAA";
txtSize=13;
txtFont="Anton:style=Regular";

tm=textmetrics(string,txtSize,txtFont);
echo(tm);


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
  charSpcng=twoChrsSz-thisChrSz-prvChrSz,
  chrOffset= (iter==0) ? stringPos : offsets[iter-1]+prvChrSz+charSpcng
) iter<(len(string)) ? getCharOffsets(string,size,font,spacing,concat(offsets,chrOffset),iter=iter+1) : offsets;
