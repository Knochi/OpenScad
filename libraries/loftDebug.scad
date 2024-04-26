// OpenSCAD loft demo, with n layers.

// Add the same amount of points for upper and lower face,
// preferably clockwise (looking from above).
// If those things are unclear, try combinations 
// of upper/lower, clockwise/counterclockwise.
// Start over matching points, otherwise the polyhedron will be twisted.
// It is possible defining the points by code.

my_upper_points = [ [0,20,20], [5,12.5,15], [10,5,10], [15,-2.5,5], 
        [20,-10,0], [10,-10,5], [0,-10,10], [-10,-10,15],       
        [-20,-10,20], [-15,-2.5,20], [-10,5,20], [-5,12.5,20] ];   
my_lower_points = [ [0,10,-20], [12,30,-20], [8,5,-20], [35,0,-20], 
        [8,-5,-20], [12,-30,-20], [0,-10,-20], [-12,-30,-20], 
        [-8,-5,-20], [-35,0,-20], [-8,5,-20], [-12,30,-20] ];     
        
// More layers make it smoother and harder to calculate.
number_of_layers = 5 ;   

loft_edge_point_numbers = len(my_upper_points);   
echo(loft_edge_point_numbers = loft_edge_point_numbers);

function even_average(number_point, index_point, number_of_layers, this_layer) = 
    ((my_upper_points[number_point][index_point] * (number_of_layers - this_layer) / number_of_layers)
    + (my_lower_points[number_point][index_point] * this_layer / number_of_layers)
    );
           
points = [
    for (i = [0 : number_of_layers])
        for (j = [0 : loft_edge_point_numbers - 1])
            [even_average(j, 0, number_of_layers, i),
            even_average(j, 1, number_of_layers, i),
            even_average(j, 2, number_of_layers, i)]
];    
//echo(points = points);

faces = [
    [for (i= [0 : loft_edge_point_numbers-1]) i], // Upper plane.
    for (i = [0 : number_of_layers -1])
        for (j = [0 : loft_edge_point_numbers - 1]) // Towards lower points.
            [loft_edge_point_numbers * i + (j+1)%loft_edge_point_numbers, 
            loft_edge_point_numbers * i + j, 
            loft_edge_point_numbers * (i+1) + j],
    for (i = [1 : number_of_layers])
        for (j = [0 : loft_edge_point_numbers - 1]) // Towards upper points.
            [loft_edge_point_numbers * i + j, 
            loft_edge_point_numbers * i + (j+1) % loft_edge_point_numbers, 
            loft_edge_point_numbers * (i-1) + (j+1) % loft_edge_point_numbers],
    [for (i= [(loft_edge_point_numbers) * (number_of_layers+1) -1  : -1 : loft_edge_point_numbers * number_of_layers ]) i], // Lower plane.
];
//echo(faces = faces);
    
module loft(upper_points, lower_points, number_of_layers)   
polyhedron( 
    points = points,
    faces = faces
);

%loft(my_upper_points, my_lower_points, number_of_layers);

// Colorful dots on every point, for depugging purposes.
many_colors = 20;                // Choose as you like, influences the rainbow.
size_debug_sphere = 1;          // Depends on the size of your model.
        
for (i= [0 : (loft_edge_point_numbers) * (number_of_layers+1) -1 ])
    color([cos(many_colors*i)/2+0.5, 
        -sin(many_colors*i)/2+0.5, 
        -cos(many_colors*i)/2+0.5, 
        1])
    translate(points[i]) sphere(size_debug_sphere);

echo(version = version());