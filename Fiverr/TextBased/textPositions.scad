txt="QEGOR Kilo";
txtSize=5.4;
txtSpcng=1.0;
txtFont="Liberation Sans:style=Regular"; //["Arial:style=Regular"]
txtHAlign="center";
txtVAlign="center";


//original text
text(txt, size=txtSize,font=txtFont,halign=txtHAlign,spacing=txtSpcng);

charPos=getCharPositions(txt,txtSize,txtFont,txtSpcng,txtHAlign);
echo(charPos);

for (i=[0:len(txt)-1]){
  trailing=textmetrics(txt[i], size=txtSize,font=txtFont,halign=txtHAlign,spacing=txtSpcng).position.x;
  translate([charPos[i]-trailing,-11]){
    text(txt[i], size=txtSize,font=txtFont,halign=txtHAlign);
    translate([trailing,0]) color("red") circle(0.7);
  }
}
  

*for (i=[0:len(txt)-1]){
  //if current char is a whitespace use next char
  thisCharSz= (txt[i]==" ") ? textmetrics(txt[i+1]).size.x : textmetrics(txt[i]).size.x;
  prevCharSz= i ? textmetrics(txt[i-1]).size.x : 0;
  //if current char is a whitespace use three chars (prev and next with a whitespace)
  subStrng=i ? ((txt[i]==" ") && (i<len(txt))) ? str(txt[i-1],txt[i],txt[i+1]) : str(txt[i-1],txt[i]) : txt[i];
  subStrngSz= i ? textmetrics(subStrng).size.x : thisCharSz;
  charSpcng=subStrngSz-thisCharSz-prevCharSz;
  //charXOffset = (halign=="center") ? (thisChrSz+prvChrSz)/2 : prvChrSz; //TODO: add "right"
  echo (subStrng,subStrngSz);
  
}

//calculate the sizes and spacings for each letter
whtSpcStr="M Mx";
whtSpcSize=getCharSizeFromString(whtSpcStr,size=txtSize,font=txtFont,halign=txtHAlign,spacing=txtSpcng,index=1);
firstCharSz=textmetrics(whtSpcStr[0],size=txtSize,font=txtFont,halign=txtHAlign,spacing=txtSpcng).size.x;
firstCharPos=textmetrics(whtSpcStr,size=txtSize,font=txtFont,halign=txtHAlign,spacing=txtSpcng).position.x;
scndCharSize=textmetrics(whtSpcStr[2],size=txtSize,font=txtFont,halign=txtHAlign,spacing=txtSpcng).size.x;
lastCharSize=textmetrics(whtSpcStr[3],size=txtSize,font=txtFont,halign=txtHAlign,spacing=txtSpcng).size.x;
lastCharSpcng=textmetrics(str(whtSpcStr[2],whtSpcStr[3]),
  size=txtSize,font=txtFont,halign=txtHAlign,spacing=txtSpcng).size.x - 
    lastCharSize-scndCharSize;

//demo
translate([0,10]){
  color("purple") square([firstCharPos,1]);
  translate([firstCharPos,0]){
    color("red") square([firstCharSz,1]);
    translate([firstCharSz,0]){
      color("green") square([whtSpcSize,1]);
      translate([whtSpcSize,0]){
        color("red") square([scndCharSize,1]);
        translate([scndCharSize,0]){
          color("blue") square([lastCharSpcng,1]);
          translate([lastCharSpcng,0]){
            color("red") square([lastCharSize,1]);
          }
        }
      }
    }
  }
}
   


translate([0,11]) text(whtSpcStr, size=txtSize,font=txtFont,halign=txtHAlign,spacing=txtSpcng);


//get the absolute positions of each char in a string
function getCharPositions(string,size,font="",spacing=1, halign="center",offsets=[],iter=0)=let(
  //get the absolute start pos of the whole string
  stringPos=textmetrics(text=string,size=size,font=font, halign=halign, spacing=spacing).position.x,
  //if previous char was a whitespace calculate the width from three chars (two chars or just " " won't work)
  prvChrSz= iter ? ((string[iter-1]==" ") && (iter>1)) ? 
    getCharSizeFromString(string,size=size,font=font,halign=halign,spacing=spacing,index=iter-1) :
    textmetrics(string[iter-1],size=size,font=font, halign=halign,spacing=spacing).size.x : 0,
  //if current char is a whitespace calculate the width from three chars
  thisChrSz=((string[iter]==" ") && iter) ? 
    getCharSizeFromString(string,size=size,font=font,halign=halign,spacing=spacing,index=iter) :
    textmetrics(string[iter],size=size,font=font, halign=halign, spacing=spacing).size.x,
    
  subStrng= iter ? str(string[iter-1],string[iter]) : string[iter], 
  subStrngSz=iter ? 
    textmetrics(subStrng,size=size,font=font, halign=halign,spacing=spacing).size.x : thisChrSz,
  charSpcng=subStrngSz-thisChrSz-prvChrSz,
  chrOffset= (iter==0) ? stringPos : (string[iter]==" ") ? 
    offsets[iter-1]+prvChrSz+thisChrSz : offsets[iter-1]+prvChrSz+charSpcng,
    
) iter<(len(string)) ? getCharPositions(string,size,font,spacing,halign,concat(offsets,chrOffset),iter=iter+1) : offsets;



function getCharSizeFromString(string,size,font="",spacing=1, halign="center", index)= 
  //this considers three chars, if possible, to get the size of whitespaces (and others)
  (index>0) && (index<len(string)-1) ?
  textmetrics(str(string[index-1],string[index],string[index+1]),
      size,font=font,spacing=spacing, halign=halign).size.x -
    textmetrics(string[index-1],size,font=font,spacing=spacing, halign=halign).size.x -
    textmetrics(string[index+1],size,font=font,spacing=spacing, halign=halign).size.x : 
    (index == 0) ?
    textmetrics(str(string[0],string[1]),size,font=font,spacing=spacing, halign=halign).size.x -
    textmetrics(string[index-1],size,font=font,spacing=spacing, halign=halign).size.x : 
    textmetrics(str(string[index-1],string[index]),size,font=font,spacing=spacing, halign=halign).size.x -
    textmetrics(string[index-1],size,font=font,spacing=spacing, halign=halign).size.x;

 
    