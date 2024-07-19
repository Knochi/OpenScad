import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
import statistics

def midpoint(p1, p2):
    return (p1 + p2) / 2

def normalize(v):
    return v / np.linalg.norm(v)

def edge_length(v1, v2):
    return np.linalg.norm(v1 - v2)

# Goldener Schnitt
phi = (1 + np.sqrt(5)) / 2 

# Eckpunkte des Ikosaeders

vertices = np.array([
    [1, phi, 0], [-1, phi, 0], [1, -phi, 0], [-1, -phi, 0],
    [0, 1, phi], [0, -1, phi], [0, 1, -phi], [0, -1, -phi],
    [phi, 0, 1], [-phi, 0, 1], [phi, 0, -1], [-phi, 0, -1]
])

# Normieren, um auf eine Einheitskugel zu passen
vertices = np.array([normalize(v) for v in vertices])

# Initiale Dreiecke des Ikosaeders
triangles = [
    (vertices[0], vertices[8], vertices[4]),
    (vertices[0], vertices[4], vertices[6]),
    (vertices[0], vertices[6], vertices[10]),
    (vertices[0], vertices[10], vertices[2]),
    (vertices[0], vertices[2], vertices[8]),
    (vertices[1], vertices[8], vertices[4]),
    (vertices[1], vertices[4], vertices[7]),
    (vertices[1], vertices[7], vertices[11]),
    (vertices[1], vertices[11], vertices[3]),
    (vertices[1], vertices[3], vertices[8]),
    (vertices[2], vertices[8], vertices[9]),
    (vertices[2], vertices[9], vertices[5]),
    (vertices[2], vertices[5], vertices[6]),
    (vertices[3], vertices[9], vertices[8]),
    (vertices[3], vertices[5], vertices[9]),
    (vertices[3], vertices[7], vertices[5]),
    (vertices[4], vertices[5], vertices[7]),
    (vertices[5], vertices[6], vertices[7]),
    (vertices[6], vertices[7], vertices[10]),
    (vertices[7], vertices[10], vertices[11])
]

# Funktion zum Unterteilen eines Dreiecks
def subdivide_triangle(v1, v2, v3):
    # Mittelpunkte der Kanten berechnen
    a = normalize(midpoint(v1, v2))
    b = normalize(midpoint(v2, v3))
    c = normalize(midpoint(v3, v1))
    
    # Neue Dreiecke zurückgeben
    return [
        (v1, a, c),
        (v2, b, a),
        (v3, c, b),
        (a, b, c)
    ]

# Neue Liste für unterteilte Dreiecke
new_triangles = []
for tri in triangles:
    new_triangles.extend(subdivide_triangle(*tri))

# Kantenlängen berechnen
edge_lengths = []
for tri in new_triangles:
    v1, v2, v3 = tri
    edge_lengths.extend([
        edge_length(v1, v2),
        edge_length(v2, v3),
        edge_length(v3, v1)
    ])

# Statistik der Kantenlängen berechnen
min_length = min(edge_lengths)
max_length = max(edge_lengths)
mean_length = statistics.mean(edge_lengths)
std_dev_length = statistics.stdev(edge_lengths)

print(f"Minimale Kantenlänge: {min_length}")
print(f"Maximale Kantenlänge: {max_length}")
print(f"Mittlere Kantenlänge: {mean_length}")
print(f"Standardabweichung der Kantenlängen: {std_dev_length}")

# Plotten des unterteilten Ikosaeders
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Zeichnen der Dreiecke
for tri in new_triangles:
    tri_vertices = np.array(tri)
    poly = Poly3DCollection([tri_vertices], facecolors='cyan', linewidths=1, edgecolors='r', alpha=.25)
    ax.add_collection3d(poly)

ax.scatter(vertices[:, 0], vertices[:, 1], vertices[:, 2])

plt.show()
