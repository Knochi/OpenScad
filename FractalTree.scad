// Tree fractal from
// https://www.wired.com/story/how-to-make-a-tree-with-fractals/


/* GlowScript Python Code
#this is the tree function
def tree(limblen,r,a):
  #theta is the "bend angle" for each branching
  theta=30*pi/180
  #short is the amount each branch decreases by
  short=15 #this is the amount each branch is decreased by
  
  #repeat the branching until the length is shorter than 5
  if limblen>5:
    #each branch is a cylinder
    #a is a vector that points in the direction of the branch
    cylinder(pos=r,axis=a*limblen)
    #r is the position of the next branch
    r=r+a*limblen
    #rotate turns the pointing direction
    a=rotate(a, angle=theta, axis=vector(0,0,1))
    #here is the recursive magic
    tree(limblen-short,r,a)
    #now you have to go back to where you were
    a=rotate(a,angle=-2*theta,axis=vector(0,0,1))
    #this does the otherside (also recursive)
    tree(limblen-short,r,a)
    a=rotate(a,angle=theta,axis=vector(0,0,1))
    r=r-limblen*a
    

#this starts the tree with the starting branchlength = 75
startingbranch=75

#this is the location of the base
startingposition=vector(0,-75,0)

#this is the direction of the first branch (up)
startingdirection=vector(0,1,0)
tree(startingbranch,startingposition, startingdirection)


*/


tree();
module tree(limbLen=75, r=[0,0,-75], a=[0,0,1]){
  theta=30; //branch angle
  short=15;
  
  
  if (limbLen>5){
    translate(r) cylinder(d=1,h=limbLen);
    rNew=r+a*limbLen;
    aNew=
  }
  
}