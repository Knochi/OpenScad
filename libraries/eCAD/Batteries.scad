//different primary and secondary cells and holders


module keyStone2998(){
  //tin-nickel finish
  //same as 3098 (Matte Tin)
  //for MC621, V364, SC621, DR13H, DR77, V13AT, 377
  ovDims=[10.7,8.0,3.0];
  sheetThck=0.25;
}

module coinCell(type="custom",dia=11.6,h=5.4){
  coinDims= (type=="custom") ?  [dia,h] :
            (type=="LR45") ? [11.6,5.4] :
            (type=="V364") ? [6.8,2.2] :
            (type=="LR41") ? [8,3] : [10,3];
  
  color("silver") cylinder(d=coinDims[0],h=coinDims[1]);
}