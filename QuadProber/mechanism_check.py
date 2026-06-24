import argparse
import itertools
import math
from typing import Any, Dict, List, Optional, Tuple

import yaml

Point = Tuple[float, float]


class YamlValidationError(ValueError):
    pass


# ------------------------------------------------------------
# Mathematische Modellierung
# ------------------------------------------------------------
def global_points_from_parameters(
    L: float,
    r1: float, r2: float, r3: float, r4: float,
    theta1: float, theta2: float, theta3: float, theta4: float,
    tx: float, ty: float, phi: float,
) -> List[Point]:
    """
    Lokale Zentren:
      cL_local = (-L/2, 0), cR_local = (+L/2, 0)

    Lokale Punkte:
      p1_local = cL_local + r1*(cos(theta1), sin(theta1))
      p2_local = cL_local + r2*(cos(theta2), sin(theta2))
      p3_local = cR_local + r3*(cos(theta3), sin(theta3))
      p4_local = cR_local + r4*(cos(theta4), sin(theta4))

    Global:
      p_global = (tx, ty) + R(phi) * p_local
    """
    cL = (-L / 2.0, 0.0)
    cR = (+L / 2.0, 0.0)

    local_pts = [
        (cL[0] + r1 * math.cos(theta1), cL[1] + r1 * math.sin(theta1)),
        (cL[0] + r2 * math.cos(theta2), cL[1] + r2 * math.sin(theta2)),
        (cR[0] + r3 * math.cos(theta3), cR[1] + r3 * math.sin(theta3)),
        (cR[0] + r4 * math.cos(theta4), cR[1] + r4 * math.sin(theta4)),
    ]

    cp, sp = math.cos(phi), math.sin(phi)
    out: List[Point] = []
    for x, y in local_pts:
        gx = tx + cp * x - sp * y
        gy = ty + sp * x + cp * y
        out.append((gx, gy))
    return out


# ------------------------------------------------------------
# Geometrie-Helfer
# ------------------------------------------------------------
def dist(a: Point, b: Point) -> float:
    return math.hypot(a[0] - b[0], a[1] - b[1])


def wrap_angle(a: float) -> float:
    while a >= math.pi:
        a -= 2.0 * math.pi
    while a < -math.pi:
        a += 2.0 * math.pi
    return a


def circle_circle_intersections(
    p0: Point, r0: float, p1: Point, r1: float, tol: float = 1e-9
) -> List[Point]:
    x0, y0 = p0
    x1, y1 = p1
    dx = x1 - x0
    dy = y1 - y0
    d = math.hypot(dx, dy)

    if d < tol:
        return []

    if d > r0 + r1 + tol:
        return []
    if d < abs(r0 - r1) - tol:
        return []

    a = (r0 * r0 - r1 * r1 + d * d) / (2.0 * d)
    h2 = r0 * r0 - a * a
    if h2 < 0 and h2 > -tol:
        h2 = 0.0
    if h2 < 0:
        return []

    h = math.sqrt(h2)
    xm = x0 + a * dx / d
    ym = y0 + a * dy / d

    if h < tol:
        return [(xm, ym)]

    rx = -dy * (h / d)
    ry = dx * (h / d)
    return [(xm + rx, ym + ry), (xm - rx, ym - ry)]


# ------------------------------------------------------------
# YAML strict validation
# ------------------------------------------------------------
def _is_finite_number(x: Any) -> bool:
    return isinstance(x, (int, float)) and math.isfinite(float(x))


def load_input_from_yaml_strict(path: str) -> Dict[str, Any]:
    with open(path, "r", encoding="utf-8") as f:
        data = yaml.safe_load(f)

    errors: List[str] = []

    if not isinstance(data, dict):
        raise YamlValidationError("Root muss ein Mapping/Objekt sein.")

    allowed_top = {"L", "radii", "target_points", "tol", "verbose"}
    unknown_top = set(data.keys()) - allowed_top
    if unknown_top:
        errors.append(f"Unbekannte Top-Level-Felder: {sorted(unknown_top)}")

    if "L" not in data:
        errors.append("Fehlendes Feld: L")
    elif not _is_finite_number(data["L"]) or float(data["L"]) <= 0:
        errors.append("L muss eine endliche Zahl > 0 sein.")

    if "radii" not in data:
        errors.append("Fehlendes Feld: radii")
    elif not isinstance(data["radii"], dict):
        errors.append("radii muss ein Objekt sein.")
    else:
        radii = data["radii"]
        for side in ("left", "right"):
            if side not in radii:
                errors.append(f"Fehlendes Feld: radii.{side}")
                continue
            v = radii[side]
            if not isinstance(v, list) or len(v) != 2:
                errors.append(f"radii.{side} muss Liste mit 2 Werten sein.")
                continue
            for i, r in enumerate(v):
                if not _is_finite_number(r) or float(r) <= 0:
                    errors.append(f"radii.{side}[{i}] muss Zahl > 0 sein.")

    if "target_points" not in data:
        errors.append("Fehlendes Feld: target_points")
    elif not isinstance(data["target_points"], list) or len(data["target_points"]) != 4:
        errors.append("target_points muss Liste mit genau 4 Punkten sein.")
    else:
        for i, p in enumerate(data["target_points"]):
            if not isinstance(p, (list, tuple)) or len(p) != 2:
                errors.append(f"target_points[{i}] muss [x,y] sein.")
                continue
            if not _is_finite_number(p[0]):
                errors.append(f"target_points[{i}][0] ungültig.")
            if not _is_finite_number(p[1]):
                errors.append(f"target_points[{i}][1] ungültig.")

    tol = data.get("tol", 1e-6)
    verbose = data.get("verbose", True)

    if not _is_finite_number(tol) or float(tol) <= 0:
        errors.append("tol muss Zahl > 0 sein.")
    if not isinstance(verbose, bool):
        errors.append("verbose muss true/false sein.")

    if errors:
        raise YamlValidationError("YAML-Validierung fehlgeschlagen:\n- " + "\n- ".join(errors))

    return {
        "L": float(data["L"]),
        "left_radii": (float(data["radii"]["left"][0]), float(data["radii"]["left"][1])),
        "right_radii": (float(data["radii"]["right"][0]), float(data["radii"]["right"][1])),
        "target_points": [(float(x), float(y)) for x, y in data["target_points"]],
        "tol": float(tol),
        "verbose": bool(verbose),
    }


# ------------------------------------------------------------
# Erreichbarkeitsprüfung (neue Logik)
# ------------------------------------------------------------
def _point_to_circle_distance(point: Point, center: Point, radius: float) -> float:
    """Abstand eines Punktes zum Kreisrand (nicht zum Mittelpunkt)."""
    d = dist(point, center)
    return abs(d - radius)


def _find_center_for_two_points_and_radii(
    p1: Point, r1: float, p2: Point, r2: float, tol: float
) -> List[Point]:
    """
    Findet mögliche Mittelpunkte, sodass p1 auf Kreis mit r1 liegt und p2 auf Kreis mit r2.
    Toleranz: Punkt darf bis zu tol vom Kreisrand entfernt sein.
    """
    # Nutze Kreisschnitt: Kreis um p1 mit Radius r1 schneidet Kreis um p2 mit Radius r2
    return circle_circle_intersections(p1, r1, p2, r2, tol=1e-9)


def _find_valid_mechanism_pose(
    target_points: List[Point],
    L: float,
    left_radii: Tuple[float, float],
    right_radii: Tuple[float, float],
    tol: float,
) -> Tuple[bool, Optional[Dict[str, Any]], Dict[str, Any]]:
    """
    Neue Logik:
    1. Für alle Zuordnungen der 4 Punkte zu (linker Ring, rechter Ring)
    2. Für alle Permutationen innerhalb der Ringe (welcher Punkt zu welchem Radius)
    3. Finde mögliche Mittelpunkte cL und cR
    4. Tracke den besten Kandidaten (minimaler kombinierter Fehler)
    5. Für exakte Lösung: |cL - cR| = L UND alle Punkte innerhalb tol
    """
    idx = [0, 1, 2, 3]
    rL_a, rL_b = left_radii
    rR_a, rR_b = right_radii

    tested_configs = 0
    best_candidate: Optional[Dict[str, Any]] = None
    best_combined_error = float("inf")

    for left_ids in itertools.combinations(idx, 2):
        right_ids = tuple(i for i in idx if i not in left_ids)

        left_pts = [target_points[left_ids[0]], target_points[left_ids[1]]]
        right_pts = [target_points[right_ids[0]], target_points[right_ids[1]]]

        for permL in [(0, 1), (1, 0)]:
            lp_a = left_pts[permL[0]]  # soll auf Radius rL_a liegen
            lp_b = left_pts[permL[1]]  # soll auf Radius rL_b liegen

            # Finde mögliche linke Mittelpunkte
            left_centers = circle_circle_intersections(lp_a, rL_a, lp_b, rL_b, tol=1e-9)
            if not left_centers:
                continue

            for permR in [(0, 1), (1, 0)]:
                rp_a = right_pts[permR[0]]  # soll auf Radius rR_a liegen
                rp_b = right_pts[permR[1]]  # soll auf Radius rR_b liegen

                # Finde mögliche rechte Mittelpunkte
                right_centers = circle_circle_intersections(rp_a, rR_a, rp_b, rR_b, tol=1e-9)
                if not right_centers:
                    continue

                for cL in left_centers:
                    for cR in right_centers:
                        tested_configs += 1
                        dcr = dist(cL, cR)
                        delta_L = abs(dcr - L)

                        # Berechne Punktfehler (Abstand zum jeweiligen Kreisrand)
                        err_lp_a = _point_to_circle_distance(lp_a, cL, rL_a)
                        err_lp_b = _point_to_circle_distance(lp_b, cL, rL_b)
                        err_rp_a = _point_to_circle_distance(rp_a, cR, rR_a)
                        err_rp_b = _point_to_circle_distance(rp_b, cR, rR_b)

                        max_point_err = max(err_lp_a, err_lp_b, err_rp_a, err_rp_b)

                        # Kombinierter Fehler: delta_L + max_point_err
                        combined_err = delta_L + max_point_err

                        if combined_err < best_combined_error:
                            best_combined_error = combined_err
                            tx = 0.5 * (cL[0] + cR[0])
                            ty = 0.5 * (cL[1] + cR[1])
                            phi = math.atan2(cR[1] - cL[1], cR[0] - cL[0])

                            best_candidate = {
                                "left_ids": left_ids,
                                "right_ids": right_ids,
                                "permL": permL,
                                "permR": permR,
                                "cL": cL,
                                "cR": cR,
                                "dcr": dcr,
                                "delta_L": delta_L,
                                "max_point_error": max_point_err,
                                "combined_error": combined_err,
                                "tx": tx,
                                "ty": ty,
                                "phi": phi,
                            }

    diagnostics = {
        "tested_configs": tested_configs,
        "best_candidate": best_candidate,
    }

    # Exakte Lösung: |cL - cR| ≈ L UND alle Punkte innerhalb tol
    if best_candidate and best_candidate["delta_L"] <= 1e-6 and best_candidate["max_point_error"] <= tol:
        # Berechne Winkel
        cL = best_candidate["cL"]
        cR = best_candidate["cR"]
        phi = best_candidate["phi"]

        left_ids = best_candidate["left_ids"]
        right_ids = best_candidate["right_ids"]
        permL = best_candidate["permL"]
        permR = best_candidate["permR"]

        left_pts = [target_points[left_ids[0]], target_points[left_ids[1]]]
        right_pts = [target_points[right_ids[0]], target_points[right_ids[1]]]

        lp_a = left_pts[permL[0]]
        lp_b = left_pts[permL[1]]
        rp_a = right_pts[permR[0]]
        rp_b = right_pts[permR[1]]

        v1 = (lp_a[0] - cL[0], lp_a[1] - cL[1])
        v2 = (lp_b[0] - cL[0], lp_b[1] - cL[1])
        v3 = (rp_a[0] - cR[0], rp_a[1] - cR[1])
        v4 = (rp_b[0] - cR[0], rp_b[1] - cR[1])

        theta = (
            wrap_angle(math.atan2(v1[1], v1[0]) - phi),
            wrap_angle(math.atan2(v2[1], v2[0]) - phi),
            wrap_angle(math.atan2(v3[1], v3[0]) - phi),
            wrap_angle(math.atan2(v4[1], v4[0]) - phi),
        )

        solution = {
            "left_indices": left_ids,
            "right_indices": right_ids,
            "left_perm_point_to_radii": permL,
            "right_perm_point_to_radii": permR,
            "center_left": cL,
            "center_right": cR,
            "tx": best_candidate["tx"],
            "ty": best_candidate["ty"],
            "phi": phi,
            "theta1_theta2_theta3_theta4": theta,
            "max_point_error": best_candidate["max_point_error"],
        }

        return True, solution, diagnostics

    return False, None, diagnostics


def check_reachability_from_cartesian_points(
    target_points: List[Point],
    L: float,
    left_radii: Tuple[float, float],
    right_radii: Tuple[float, float],
    tol: float = 1e-6,
    verbose: bool = True,
) -> Tuple[bool, Optional[Dict[str, Any]], Dict[str, Any]]:
    if len(target_points) != 4:
        raise ValueError("Es müssen genau 4 Zielpunkte angegeben werden.")

    ok, solution, diagnostics = _find_valid_mechanism_pose(
        target_points, L, left_radii, right_radii, tol
    )

    if verbose:
        if ok:
            print("Erreichbar: JA")
            print(f"  max Punktfehler: {solution['max_point_error']:.6e} (tol={tol})")
        else:
            print("Erreichbar: NEIN")
            print(f"  Geprüfte Konfigurationen: {diagnostics['tested_configs']}")
            if diagnostics.get("best_candidate"):
                bc = diagnostics["best_candidate"]
                print(f"  Beste Annäherung: delta_L={bc['delta_L']:.6e}, max_point_error={bc['max_point_error']:.6e}")

    return ok, solution, diagnostics


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="2D-Mechanismusprüfung aus YAML")
    parser.add_argument("-c", "--config", required=True, help="Pfad zur YAML-Datei")
    args = parser.parse_args()

    try:
        cfg = load_input_from_yaml_strict(args.config)
    except (OSError, yaml.YAMLError, YamlValidationError) as e:
        print(f"Fehler beim Laden der YAML-Datei:\n{e}")
        raise SystemExit(2)

    ok, solution, diagnostics = check_reachability_from_cartesian_points(
        target_points=cfg["target_points"],
        L=cfg["L"],
        left_radii=cfg["left_radii"],
        right_radii=cfg["right_radii"],
        tol=cfg["tol"],
        verbose=cfg["verbose"],
    )
    print(f"\nFinales Ergebnis: {ok}")
    if not ok and diagnostics.get("best_candidate"):
        bc = diagnostics["best_candidate"]
        print(f"Bester max_point_error: {bc['max_point_error']:.6e}")
        print(f"Bestes delta_L: {bc['delta_L']:.6e}")