// --- VARIABLES ---
// roughly the size of parts of curves
fs = 0.5;

// points
p1 = [0, 0]; //start
p2 = [3, 0]; //control 1
p3 = [7, 1];  // control 2
p4 = [9, 1]; //end

// --- FUNCTIONS AND MODULES ---
// calculates the amount of points
// from distance of two points and fs
function fn(a, b) =
  round(sqrt(pow(a[0]-b[0],2)
  + pow(a[1]-b[1], 2))/fs);

// calculate each individual point
function b_pts(pts, n, idx) =
  len(pts)>2 ?
    b_pts([for(i=[0:len(pts)-2])
        pts[i]], n, idx) * n*idx
      + b_pts([for(i=[1:len(pts)-1])
        pts[i]], n, idx) * (1-n*idx)
    : pts[0] * n*idx
      + pts[1] * (1-n*idx);

// calculate fn() for given points,
// call b_pts() and concatenate points
function b_curv(pts) =
  let (fn=fn(pts[0], pts[len(pts)-1]))
    [for (i= [0:fn])
      concat(b_pts(pts, 1/fn, i))];

// displaying points as a rainbow
module rainbow (points) {
for (i= [0 : len(points)-1 ])
  color([cos(20*i)/2+0.5,
    -sin(20*i)/2+0.5,
    -cos(20*i)/2+0.5,
    1])
  translate(points[i]) sphere(0.5, $fn=10);
}

// --- THE ACTUAL MODEL ---
// calculating the points
points = b_curv([p1, p2, p3, p4]);

// displaying the calculated points
rainbow(points);

// displaying [p1 .. p4]
for (i=[p1, p2, p3, p4])
  translate(i) color("black")
    cylinder(1, 0.2, 0.2, $fn=10);