$fn = 100;

shape1 = [ [10, 10, 8], [0, 40, 3], [40, 50, -10], [100, 80, 10], [50, 0, 20] ];

rounded_polygon(shape1);

module rounded_polygon(points)
    difference() {
        len = len(points);
        union() {
            for(i = [0 : len - 1]) //for each points in points
                if(points[i][2] > 0) //if there is a radius
                    translate([points[i].x, points[i].y]) //shift the circle center to point.x .y
                        #circle(points[i][2]); //draw circle with radius point[2]

            polygon([for(i  = [0 : len - 1]) //draw polygon over tangents#
              //calculate the tangent between this and the next point (circle centers with radii!)
                        let(ends = tangent(points[i], points[(i + 1) % len])) 
                            for(end = [0, 1])
                                ends[end]]);
        }
        for(i = [0 : len - 1])
            if(points[i][2] < 0)
                translate([points[i].x, points[i].y])
                    circle(-points[i][2]);
     }

function tangent(p1, p2) =
    let(
        r1 = p1[2],
        r2 = p2[2],
        dx = p2.x - p1.x,
        dy = p2.y - p1.y,
        d = sqrt(dx * dx + dy * dy),
        theta = atan2(dy, dx) + acos((r1 - r2) / d),
        xa = p1.x +(cos(theta) * r1),
        ya = p1.y +(sin(theta) * r1),
        xb = p2.x +(cos(theta) * r2),
        yb = p2.y +(sin(theta) * r2)
    )[ [xa, ya], [xb, yb] ];