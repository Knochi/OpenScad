# Four Point Mechanism Analysis

This project analyzes a 2D mechanism consisting of four points. The main functionalities include calculating the positions of the points based on their respective angles and radii, computing their global coordinates, and checking if specified target points can be reached through permutations of the calculated positions.

## Project Structure

```
four-point-mechanism
├── src
│   ├── mechanism.py        # Main logic for analyzing the 2D mechanism
│   └── types
│       └── __init__.py     # Placeholder for future type definitions
├── tests
│   └── test_mechanism.py   # Unit tests for the mechanism functions
├── requirements.txt         # Project dependencies
└── README.md                # Project documentation
```

## Installation

To set up the project, clone the repository and install the required dependencies. You can do this by running:

```bash
pip install -r requirements.txt
```

## Usage

To analyze the mechanism, you can use the functions defined in `mechanism.py`. Here is a brief overview of the main functions:

- `calculate_point_positions(r1, r2, r3, r4, theta1, theta2, theta3, theta4)`: 
  - Calculates the positions of the four points based on their respective angles and radii.
  
- `global_coordinates(tx, ty, phi, positions)`:
  - Computes the global coordinates of the points after applying translation and rotation.
  
- `check_target_reachability(target_points, point_positions, L)`:
  - Checks if the target points can be reached by any permutation of the calculated point positions, considering the geometric constraints.

## Running Tests

To ensure that the calculations and functionalities work as expected, you can run the unit tests provided in `test_mechanism.py`. Use the following command:

```bash
pytest tests/test_mechanism.py
```

## Example

Here is a small example of how to use the functions:

```python
from src.mechanism import calculate_point_positions, global_coordinates, check_target_reachability

# Define parameters
radii = (1, 1, 1, 1)
angles = (0, 90, 180, 270)

# Calculate point positions
positions = calculate_point_positions(*radii, *angles)

# Define translation and rotation
translation = (2, 3)
rotation_angle = 45

# Get global coordinates
global_pos = global_coordinates(*translation, rotation_angle, positions)

# Check reachability of target points
target_points = [(3, 4), (5, 6)]
reachable = check_target_reachability(target_points, global_pos, L=1)

print("Global Positions:", global_pos)
print("Reachable Targets:", reachable)
```

## License

This project is licensed under the MIT License. See the LICENSE file for more details.