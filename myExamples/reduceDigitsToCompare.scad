coords=[
  [0,0],            //0
  [-15, 8.6602534], //1
  [0, 17.320553],   //2
  [15, 8.6602535],  //3
  [30, 17.320531],  //4
  [15, 25.980824],  //5
  [15, 43.301312]   //6
  ];
  
pos = [15,25.980812];

test();

module test(){
  for (i=[0:len(coords)-1])
    if (degrade2D(coords[i])==degrade2D(pos))
      echo("HIT",i);
}


function degrade2D(vector,digits=3)=[degrade(vector[0],digits),degrade(vector[1],digits)];

function degrade(value,digits=4)=floor(value * pow(10,digits))/pow(10,digits);
  
  

