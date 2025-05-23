// Tutorial Tangent Lines.scad
//
// This is a script used for a tutorial about
// the tangent lines of a circle.
// This tutorial uses the file "Tangent Lines.scad".
//
// Version 1
// October 6, 2024
// by: Stone Age Sculptor
// License: CC0 (Public Domain)
// Compatible with OpenSCAD version from 2021 and 2024.
//
// Version 2
// October 11, 2024
// by: Stone Age Sculptor
// License: CC0 (Public Domain)
//   Demonstration added for intersection 
//   and connection points for circles.
//

$fn = 100;

include <Tangent Lines.scad>

assert(TANGENT_LINES_VERSION >= 3, "Use at least a Version 3 of \"Tangen Lines.scad\"");

// The part of the tutorial.
tutorial_section = 0;

// The line width, which is used throughout the whole script.
line_width = 0.7;

// The two circles, used for the tutorial.
C1 = [-35,25];
R1 = 30;
N1 = "A";
F1 = "Green";

C2 = [20,-5];
R2 = 15;
N2 = "B";
F2 = "Blue";

Tutorial(tutorial_section);

module Tutorial(tutorial)
{
  if(tutorial==0)
  {
    // Classic way for external tangent lines,
    // with a parallel line inside the circle.

    TutorialCircle(C1,"C1",R1,"R1",N1,F1);
    TutorialCircle(C2,"C2",R2,"R2",N2,F2);

    // Draw a line between the centre points.
    translate([0,0,0.5])
      color("Red")
        Line(C1,C2);

    // Draw the parallel line.
    a = atan2((C1-C2).y,(C1-C2).x) + 180;
    Vector = [cos(a+90),sin(a+90)];
    Z1 = C1 + R2 * Vector;
    Z2 = C2 + R2 * Vector;
    translate([0,0,0.5])
      color("Orange")
        Line(Z1,Z2);
  }
  else if(tutorial==1)
  {
    // Classic way for internal tangent lines,
    // with a parallel line outside the circle.

    TutorialCircle(C1,"C1",R1,"R1",N1,F1);
    TutorialCircle(C2,"C2",R2,"R2",N2,F2);

    // Draw a line between the centre points.
    translate([0,0,0.5])
      color("Red")
        Line(C1,C2);

    // Draw the parallel line.
    a = atan2((C1-C2).y,(C1-C2).x) + 180;
    Vector = [cos(a+90),sin(a+90)];
    Z1 = C1 + R1 * Vector;
    Z2 = C2 + R1 * Vector;
    translate([0,0,0.5])
      color("Orange")
        Line(Z1,Z2);
  }
  else if(tutorial==2)
  {
    // Calculate the tangent points
    // with the common tangent point and
    // similar triangles.

    TutorialCircle(C1,"C1",R1,"R1",N1,F1);
    TutorialCircle(C2,"C2",R2,"R2",N2,F2);

    // The external tangent point for the two circles.
    T1 = PointForExternal(C1,R1,C2,R2);
    // The tangent points for the first circle.
    P1 = TangentPoints(C1,R1,T1);
    // The tangent points for the second circle.
    P2 = TangentPoints(C2,R2,T1);

    // Draw the points and the tangent lines.
    // Height level 5.
    translate([0,0,5])
      color("Blue")
      {
        Point(T1,"T1");
        Point(P1[0],"P1[0]");
        Point(P1[1],"P1[1]");
        Point(P2[0],"P2[0]");
        Point(P2[1],"P2[1]");

        // Lines are draw to all the tangent lines.
        // That means that they will overlap,
        // which is no problem.
        Line(T1,P1[0]);
        Line(T1,P1[1]);
        Line(T1,P2[0]);
        Line(T1,P2[1]);
      }

    // Draw two triangles.
    // Height level 4.
    translate([0,0,4])
    {
      color("LawnGreen",0.5)
        polygon([C1,P1[1],T1]);
      translate([0,0,0.5])
        color("Orange",0.8)
          polygon([C2,P2[1],T1]);
    }
  }
  else if(tutorial==3)
  {
    // Calculate the tangent points
    // with the common tangent point
    // and similar triangles.

    TutorialCircle(C1,"C1",R1,"R1",N1,F1);
    TutorialCircle(C2,"C2",R2,"R2",N2,F2);

    // The internal tangent point for the two circles.
    T2 = PointForInternal(C1,R1,C2,R2);
    // The tangent points for the first circle.
    Q1 = TangentPoints(C1,R1,T2);
    // The tangent points for the second circle.
    Q2 = TangentPoints(C2,R2,T2);

    // Draw the points and the tangent lines.
    // Height level 5.
    translate([0,0,5])
      color("Red")
      {
        Point(T2,"T2");
        Point(Q1[0],"Q1[0]");
        Point(Q1[1],"Q1[1]");
        Point(Q2[0],"Q2[0]");
        Point(Q2[1],"Q2[1]");

        // Lines are draw to all the tangent lines.
        // That means that they will overlap,
        // which is no problem.
        Line(T2,Q1[0]);
        Line(T2,Q1[1]);
        Line(T2,Q2[0]);
        Line(T2,Q2[1]);
      }

    // Draw two triangles.
    // Height level 4.
    translate([0,0,4])
    {
      color("LawnGreen",0.5)
        polygon([C1,Q1[1],T2]);
      translate([0,0,0.5])
        color("Orange",0.8)
          polygon([C2,Q2[1],T2]);
    }
  }
  else if(tutorial==4 || tutorial==5)
  {
    // A demonstration for tangent lines.
    // I have my doubts if this is a good demonstration,
    // because a similar shape can be made with the
    // offset() function or with bezier functions.

    C10 = [0,120];
    R10 = 15;
    C11 = [40,110];
    R11 = 22;
    C12 = [30,70];
    R12 = 15;
    C13 = [55,40];
    R13 = 20;
    C14 = [50,15];
    R14 = 15;

    T10 = PointForInternal(C10,R10,C11,R11);
    T11 = PointForInternal(C11,R11,C12,R12);
    T12 = PointForInternal(C12,R12,C13,R13);
    T13 = PointForExternal(C13,R13,C14,R14);

    P11 = TangentPoints(C10,R10,T10)[0];
    P12 = TangentPoints(C11,R11,T10)[0];
    P13 = TangentPoints(C11,R11,T11)[1];
    P14 = TangentPoints(C12,R12,T11)[1];
    P15 = TangentPoints(C12,R12,T12)[0];
    P16 = TangentPoints(C13,R13,T12)[0];
    P17 = TangentPoints(C13,R13,T13)[1];
    P18 = TangentPoints(C14,R14,T13)[1];
    P19 = TangentPoints(C14,R14,[0,0])[1];

    if(tutorial==4)
    {
      translate([0,0,1])
      {
        color("Blue")
          translate(C10)
            circle(R10);

        color("Red")
          translate(C11)
            circle(R11);

        color("LawnGreen")
          translate(C12)
            circle(R12);

        color("Orange")
          translate(C13)
            circle(R13);

        translate([0,0,0.5])
          color("Purple")
            translate(C14)
              circle(R14);
      }
      translate(C11)
        circle(R11);
      translate(C13)
        circle(R13);
      translate(C14)
        circle(R14);
      polygon([[0,0],[0,C10.y-R10],P11,P12,P13,P14,P15,P16,P17,P18,P19]);
    }

    if(tutorial==5)
      rotate_extrude()
        difference()
        {
          union()
          {
            translate(C11)
              circle(R11);
            translate(C13)
              circle(R13);
            translate(C14)
              circle(R14);
            polygon([[0,0],[0,C10.y-R10],P11,P12,P13,P14,P15,P16,P17,P18,P19]);
          }
          translate(C10)
            circle(R10);
          translate(C12)
            circle(R12);
        }
  }
  else if(tutorial==6)
  {
    // Intersecting points of two
    // overlapping circles.

    C3 = [5,-15];
    R3 = 40;
    N3 = "C";
    F3 = "Purple";
    TutorialCircle(C1,"C1",R1,"R1",N1,F1);
    translate([0,0,0.5])
      TutorialCircle(C3,"C3",R3,"R3",N3,F3);

    K = IntersectionPoints(C1,R1,C3,R3);
    color("Red")
      translate([0,0,5])
      {
        Point(K[0],"K[0]");
        Point(K[1],"K[1]");
      }
  }
  else if(tutorial==7)
  {
    // Touch point of two circles.
    R4 = 40;
    N4 = "D";
    F4 = "Gray";

    // Calculate the coordinates of the second circle,
    // it will be 45 degrees right-below the first circle.
    distance = R1 + R4;
    C4 = [C1.x + distance/sqrt(2), C1.y - distance/sqrt(2)];

    TutorialCircle(C1,"C1",R1,"R1",N1,F1);
    translate([0,0,0.5])
      TutorialCircle(C4,"C4",R4,"R4",N4,F4);

    L = TouchPoint(C1,R1,C4,R4);
    color("Red")
      translate([0,0,5])
        Point(L,"L");
  }
  else if(tutorial==8)
  {
    // For a picture to be used as the
    // main screendump picture for this project.

    TutorialCircle(C1,"C1",R1,"R1",N1,F1);
    TutorialCircle(C2,"C2",R2,"R2",N2,F2);

    // The external tangent point for the two circles.
    T1 = PointForExternal(C1,R1,C2,R2);
    // The tangent points for the first circle.
    P1 = TangentPoints(C1,R1,T1);
    // The tangent points for the second circle.
    P2 = TangentPoints(C2,R2,T1);
    // The internal tangent point for the two circles.
    T2 = PointForInternal(C1,R1,C2,R2);
    // The tangent points for the first circle.
    Q1 = TangentPoints(C1,R1,T2);
    // The tangent points for the second circle.
    Q2 = TangentPoints(C2,R2,T2);

    // Draw the points and the tangent lines.
    // Height level 5.
    translate([0,0,5])
      color("Blue")
      {
        Point(T1,"T1");
        Point(P1[0],"P1[0]");
        Point(P1[1],"P1[1]");
        Point(P2[0],"P2[0]");
        Point(P2[1],"P2[1]");

        // Lines are draw to all the tangent lines.
        // That means that they will overlap,
        // which is no problem.
        Line(T1,P1[0]);
        Line(T1,P1[1]);
        Line(T1,P2[0]);
        Line(T1,P2[1]);
      }

    // Draw the points and the tangent lines.
    // Height level 5.
    translate([0,0,5])
      color("Red")
      {
        Point(T2,"T2");
        Point(Q1[0],"Q1[0]");
        Point(Q1[1],"Q1[1]");
        Point(Q2[0],"Q2[0]");
        Point(Q2[1],"Q2[1]");

        // Lines are draw to all the tangent lines.
        // That means that they will overlap,
        // which is no problem.
        Line(T2,Q1[0]);
        Line(T2,Q1[1]);
        Line(T2,Q2[0]);
        Line(T2,Q2[1]);
      }
  }
  else if(tutorial==9)
  {
    // Demonstration for intersection and
    // touch points of circles.
    if($preview)
    {
      color("Blue",0.5)
        TutorialIntersectTouch2D(0);

      color("Red",0.5)
        TutorialIntersectTouch2D(1);

      color("Black")
        translate([0,0,1.5])
        TutorialIntersectTouch2D(4);

      color("Gold",0.4)
        translate([0,0,2])
        TutorialIntersectTouch2D(2);
    }

    color("Maroon")
      translate([110,0,0])
        linear_extrude(5)
        {
          difference()
          {    
            TutorialIntersectTouch2D(0);
            offset(-5)
              TutorialIntersectTouch2D(0);
          }

          difference()
          {
            TutorialIntersectTouch2D(3);
            offset(-5)
              TutorialIntersectTouch2D(3);
          }
        }
  }
}

// Helper function to draw the circles
// and make calculations for the demonstration
// for the Intersection and Touch points
// of two circles.
// An animation can be used for changing
// the radius of all big circles.
module TutorialIntersectTouch2D(mode)
{
  // $t changes from 0 to 1
  Rsmall = 10;
  Rbig   = (2 + (1+sin($t*360))) * Rsmall;
  pos    = 30;
  
  // Make a list with the coordinates.
  Csmall = [for(a=[0,120,240]) [pos*cos(a), pos*sin(a)]];

  // Calculate the center of the larger circle.
  // The radius of the larger circle is added
  // to the smaller circle and the crossing
  // between two circles is taken.
  Cbig = [
    IntersectionPoints(Csmall[0],Rsmall+Rbig,Csmall[1],Rsmall+Rbig)[1],
    IntersectionPoints(Csmall[1],Rsmall+Rbig,Csmall[2],Rsmall+Rbig)[1],
    IntersectionPoints(Csmall[2],Rsmall+Rbig,Csmall[0],Rsmall+Rbig)[1]];

  // All the six touch points of the small circle
  // with the big circles are calculated.
  Ptouch = [
    TouchPoint(Csmall[0],Rsmall,Cbig[0],Rbig),
    TouchPoint(Csmall[1],Rsmall,Cbig[0],Rbig),
    TouchPoint(Csmall[1],Rsmall,Cbig[1],Rbig),
    TouchPoint(Csmall[2],Rsmall,Cbig[1],Rbig),
    TouchPoint(Csmall[2],Rsmall,Cbig[2],Rbig),
    TouchPoint(Csmall[0],Rsmall,Cbig[2],Rbig)];

  if(mode==0)
  {
    for(i=[0:2])
      translate(Csmall[i])
        circle(Rsmall);
  }
  else if(mode==1)
  {
    for(i=[0:2])
      translate(Cbig[i])
        circle(Rbig);
  }
  else if(mode==2)
  {
    polygon(Ptouch);
  }
  else if(mode==3)
  {
    // This mode calculates the basic shape.
    // First the polygon is taken, then
    // the small circles are added and
    // the big circles are removed.
    // This function is called recursively,
    // because it is a combination of
    // things that already exist in this function.
    difference()
    {
      union()
      {
        TutorialIntersectTouch2D(2);
        TutorialIntersectTouch2D(0);
      }
      TutorialIntersectTouch2D(1);
    }
  }
  else if(mode==4)
  {
    // These are the two black circle edges.
    translate(Csmall[0])
      difference()
      {
        circle(Rsmall+Rbig+line_width/2);
        circle(Rsmall+Rbig-line_width/2);
      }
    translate(Csmall[2])
      difference()
      {
        circle(Rsmall+Rbig+line_width/2);
        circle(Rsmall+Rbig-line_width/2);
      }
  }
} 

// Draw a circle for this tutorial 
// with optional name and color fill.
module TutorialCircle(centre,centreName,radius,radiusName,name="",fill_color="")
{
  translate(centre)
  {
    // The full circle with optional color fill.
    // Height level 0.
    if(fill_color != "")
      color(fill_color,0.2)
        circle(radius);

    // The optional name in gray.
    // Height level 0.5 to avoid touching level 2.
    // Level 2 has a difference() function, anything touching it
    // creates patterns in the preview.
    if(name != "")
      color("Gray")
        translate([-6,-5,0.5])
          text(name,size=13,halign="center",valign="center");

    // The center point of the circle in black.
    // Height level 2.
    color("Black")
      translate([0,0,2])
        Point([0,0],centreName);

    // The edge of the circle in black.
    // Height level 2.
    color("Black")
      translate([0,0,2])
        difference()
        {
          circle(radius+line_width/2);
          circle(radius-line_width/2);
        }

    // An arrow with the radius name in black.
    // Height level 2.
    if(radiusName != "")
      color("Black")
        translate([0,0,2])
          rotate(90)
          {
            Line([2.5,0],[radius-1.5,0]);
            Line([radius-1.5,0],[radius-6,-2]);
            Line([radius-1.5,0],[radius-6,2]);
            translate([radius/2-1,1])
              text(radiusName,size=3,halign="center");
          }
  }
}

// Draw a line for this tutorial with round end caps.
// Let's try the smart code by Reddit user oldesole1:
// Reference:
//   https://www.reddit.com/r/openscad/comments/1fqa33m/i_spent_a_few_days_in_tangent_lines/
module Line(point1,point2)
{
  hull()
    for (pos = [point1,point2])
      translate(pos)
        circle(d = line_width);
}

// Draw a point for this tutorial with optional text.
module Point(coordinates,optional_text="")
{
  translate(coordinates)
  {
    circle(2*line_width);
    translate([1.8,2.5])
      text(optional_text,size=3);
  }
}
