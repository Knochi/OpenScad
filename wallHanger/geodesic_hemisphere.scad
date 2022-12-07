/*
Geodesic Hemisphere
by Alex Matulich, April 2021
Requires OpenSCAD version 2019.05 or greater.

On Thingiverse: https://www.thingiverse.com/thing:4816358
On Prusaprinters: https://www.prusaprinters.org/prints/129119-geodesic-hemisphere-with-regular-polygon-equator

February 2022:
* Simplifications and improvements made throughout the code by Benjamin Blankertz, particularly a better approach to finding the closest root polygon match to any $fn value requested for the hemisphere.
* Root pyramid can now have up to 7 sides (was 6), giving a few more equatorial polygon possibilities.

Subdivision functions are taken from Geodesic Sphere (icosahedral sphere) by Jamie Kawabata - https://www.thingiverse.com/thing:1484333

USAGE
-----
To use this, simply put this file in the directory where you keep .scad files, and include this line in your other .scad files:

use <geodesic_hemisphere.scad>

Use it exactly like you would use the OpenSCAD sphere() primitive, with the same parameters.

EXPLANATION
-----------
This is a hemisphere with evenly-distributed faces, and unlike an icosahedral sphere, this hemisphere is rendered so that the equator is a regular polygon that can match up with other regular polygon shapes (cylinders etc.).

The default sphere in OpenSCAD is rendered as a circle rotated around a diameter. This results in a globe-shape with longitude and latitude edges, with many wasted facets concentrated at the poles.

To get a sphere with more uniformly-spaced facets, one can subdivide the triangular faces of an icosahedron into smaller faces projected onto a circumscribed sphere. This has three problems:

1. An icosahedron doesn't have an equator, so it is difficult to match another polygonal shape to it.
2. The cross-section of a regular icosahedron can be a regular decagon (orient it with a vertex at each pole and cut through an equatorial plane), but the diameter is slightly smaller than the largest diameter of the icosahedron.
3. An icosahedron is limited in the number of sides available in the polygon equator if you cut it in half. At a minimum, an icosahedron cut in half has a 10-sided equator. Subdividing it, you can get 20 sides, 40 sides, 80 sides... 5*2^(levels+1) sides, where levels is the number of subdivision iterations (with levels=0 being the original icosahedron).

This model fixes all problems for a hemisphere, which is normally what one wants to use when matching to some other shape like a cylinder. It subdivides a pyramid (3, 4, 5, 6, or 7 sided), which results in the base of the hemisphere being a regular polygon of the specified diameter of the hemisphere. The polygon can also have a larger variety of sides: 3*2^levels, 4*2^levels, 5*2^levels, 6*2^levels or 7*2^levels. This means the number of polygon sides possible is 3, 4, 5, 6, 7, 8, 10, 12, 14, 16, 20, 24, 28, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, etc. (one should never need to go higher than 192 or so).
*/

// ---------- demo ----------

for(i=[4:7]) {
    // root pyramids, 4 to 7 sides
    translate([(i-5.5)*21,11,0]) geodesic_hemisphere(r=10, $fn=i);
    // subdivided pyramids
    translate([(i-5.5)*21,-11,0]) geodesic_hemisphere(r=10, $fn=4*i);
}

// ---------- generate hemisphere ----------

module geodesic_hemisphere(r=-1, d=-1) {
    rad = r > 0 ? r : d > 0 ? d/2 : 1; //radius=1 by default
    fn = $fn ? $fn : max(360/$fa, 2*PI*rad/$fs);

    // given fn, figure out best root polygon and number of levels to subdivide
    log2 = log(2.0);
    logfn = log(fn);
    minpoly = fn < 6 ? 3 : 4; // can use 3-sided if fn<=6
    maxpoly = fn > 6 ? 7 : 6;
    // pn[]=possible subdivision levels for polygon having number of sides = npoly * 2^pn
    pn = [ for(i=[minpoly:maxpoly]) (logfn-log(i))/log2 ];

    // how far the provided number of vertices will deviate from fn (bb)
    dpn = [ for(i=[0:len(pn)-1]) each
            [ abs((minpoly+i)*2^floor(pn[i]) - fn),
              abs((minpoly+i)*2^ceil(pn[i]) - fn) ] ];
    minidx = floor(argmin(dpn)/2); // get closest match

    npoly = minidx + minpoly; // sides of root polygon
    levels = floor(pn[minidx]) + argmin(dpn)%2; // subdivision levels
    //echo(requested = fn, got = npoly*2^levels, npoly = npoly);

    pyramid = [ // define a pyramid with npoly sides
        // vertices
        [ [0,0,1],         // north pole
          let(a=360/npoly) // equator
            for(i=[0:npoly-1]) [ cos(i*a), sin(i*a), 0]
        ],
        // faces
        [ [0,1,npoly], for(i=[1:npoly-1]) [0,i+1,i] ]
    ];

    // subdivide the pyramid
    subdiv_pyramid = multi_subdiv_pf(pyramid, levels);
    // create base vertices and append them
    basepts = let(lv=npoly*pow(2,levels)) [for(n=[0:lv]) let(t=n*360/lv) [cos(t), sin(t), 0]];
    hpts = concat(subdiv_pyramid[0], basepts);
    // create base face and add it
    baseface = [ let(lv=npoly*pow(2,levels), 
                     pstart=len(hpts)-lv)
                 [ for(n=[0:lv-1]) pstart+n ]
               ];
    hfcs = concat(subdiv_pyramid[1], baseface);
    // render the cap
    scale(rad) polyhedron(points=hpts, faces=hfcs);

    // ========== functions ==========
    // taken from https://www.thingiverse.com/thing:1484333 by Jamie Kawabata

    // return the index of the minimum value in an array
    function argmin(v, k=0, mem=[-1, ceil(1/0)]) = 
        (k == len(v)) ? mem[0] :
            v[k] < mem[1] ? argmin(v, k+1, [k, v[k]]) : 
            argmin(v, k+1, mem);

    // polyhedron subdivision functions

    // given two 3D points on the unit sphere, find the half-way point on the great circle (euclidean midpoint renormalized to be 1 unit away from origin)

    function midpt(p1, p2) = 
        let(mid = 0.5 * (p1 +p2))
        mid / norm(mid);
  
    // given a "struct" where pf[0] is vertices and pf[1] is faces, subdivide all faces into 4 faces by dividing each edge in half along a great circle (midpt function) and returns a struct of the same format, i.e. pf[0] is a (larger) list of vertices and pf[1] is a larger list of faces.

    function subdivpf(pf) =
        let (p=pf[0], faces=pf[1])
        [ // for each face, output six points
            [ for (f=faces) 
                let (p0 = p[f[0]], p1 = p[f[1]], p2=p[f[2]]) 
                each
                [ p0, p1, p2, midpt(p0, p1), midpt(p1, p2), midpt(p0, p2) ]
            ],
        // now, again for each face, output four faces that connect those six points
            [ for (i=[0:len(faces)-1])
                let (base = 6*i)  // points generated in multiples of 6
                each
                [[base, base+3, base+5], 
                 [base+3, base+1, base+4],
                 [base+5, base+4, base+2],
                 [base+3, base+4, base+5]
                ]
            ]
        ];

    // recursive wrapper for subdivpf that subdivides "levels" times
    function multi_subdiv_pf(pf, levels) =
        levels == 0 ? pf :
        multi_subdiv_pf(subdivpf(pf), levels-1);
}
