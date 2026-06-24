import unittest
from src.mechanism import calculate_point_positions, global_coordinates, check_target_reachability

class TestMechanism(unittest.TestCase):

    def test_calculate_point_positions(self):
        r1, r2, r3, r4 = 1, 1, 1, 1
        theta1, theta2, theta3, theta4 = 0, 90, 180, 270
        expected_positions = [
            (1.0, 0.0), 
            (0.0, 1.0), 
            (-1.0, 0.0), 
            (0.0, -1.0)
        ]
        positions = calculate_point_positions(r1, r2, r3, r4, theta1, theta2, theta3, theta4)
        self.assertEqual(positions, expected_positions)

    def test_global_coordinates(self):
        tx, ty, phi = 1, 1, 90
        positions = [(1.0, 0.0), (0.0, 1.0), (-1.0, 0.0), (0.0, -1.0)]
        expected_global_positions = [
            (1.0, 1.0), 
            (0.0, 2.0), 
            (0.0, 1.0), 
            (1.0, 0.0)
        ]
        global_pos = global_coordinates(tx, ty, phi, positions)
        self.assertEqual(global_pos, expected_global_positions)

    def test_check_target_reachability(self):
        target_points = [(1, 1), (0, 2), (0, 1), (1, 0)]
        point_positions = [(1.0, 1.0), (0.0, 2.0), (0.0, 1.0), (1.0, 0.0)]
        L = 1.5
        reachable = check_target_reachability(target_points, point_positions, L)
        self.assertTrue(reachable)

if __name__ == '__main__':
    unittest.main()