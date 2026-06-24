def calculate_point_positions(r1, r2, r3, r4, theta1, theta2, theta3, theta4):
    """
    Calculate the positions of the four points based on their respective angles and radii.
    
    Parameters:
    r1, r2, r3, r4: Radii for the four points.
    theta1, theta2, theta3, theta4: Angles in radians for the four points.
    
    Returns:
    A list of tuples representing the (x, y) positions of the four points.
    """
    import math
    
    positions = [
        (r1 * math.cos(theta1), r1 * math.sin(theta1)),
        (r2 * math.cos(theta2), r2 * math.sin(theta2)),
        (r3 * math.cos(theta3), r3 * math.sin(theta3)),
        (r4 * math.cos(theta4), r4 * math.sin(theta4))
    ]
    
    return positions


def global_coordinates(tx, ty, phi, positions):
    """
    Compute the global coordinates of the points after applying translation and rotation.
    
    Parameters:
    tx, ty: Translation values in the x and y directions.
    phi: Rotation angle in radians.
    positions: List of tuples representing the local (x, y) positions of the points.
    
    Returns:
    A list of tuples representing the global (x, y) coordinates of the points.
    """
    import math
    
    global_positions = []
    for x, y in positions:
        # Apply rotation
        x_rotated = x * math.cos(phi) - y * math.sin(phi)
        y_rotated = x * math.sin(phi) + y * math.cos(phi)
        
        # Apply translation
        x_global = x_rotated + tx
        y_global = y_rotated + ty
        
        global_positions.append((x_global, y_global))
    
    return global_positions


def check_target_reachability(target_points, point_positions, L):
    """
    Check if the target points can be reached by any permutation of the calculated point positions.
    
    Parameters:
    target_points: List of tuples representing the target (x, y) points.
    point_positions: List of tuples representing the calculated (x, y) positions of the points.
    L: Maximum allowable distance for reachability.
    
    Returns:
    True if any permutation of point_positions can reach target_points within distance L, False otherwise.
    """
    from itertools import permutations
    
    for perm in permutations(point_positions):
        for target in target_points:
            for point in perm:
                distance = ((point[0] - target[0]) ** 2 + (point[1] - target[1]) ** 2) ** 0.5
                if distance <= L:
                    break
            else:
                continue
            break
        else:
            return True
    
    return False


# Example test case
if __name__ == "__main__":
    # Define parameters
    r1, r2, r3, r4 = 1, 1, 1, 1
    theta1, theta2, theta3, theta4 = 0, math.pi/2, math.pi, 3*math.pi/2
    
    # Calculate point positions
    positions = calculate_point_positions(r1, r2, r3, r4, theta1, theta2, theta3, theta4)
    
    # Define translation and rotation
    tx, ty, phi = 2, 2, math.pi/4
    
    # Get global coordinates
    global_positions = global_coordinates(tx, ty, phi, positions)
    
    # Define target points and check reachability
    target_points = [(3, 3), (4, 4)]
    L = 2.5
    can_reach = check_target_reachability(target_points, global_positions, L)
    
    print("Global Positions:", global_positions)
    print("Can reach target points:", can_reach)