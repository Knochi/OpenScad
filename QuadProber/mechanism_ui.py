import tkinter as tk
from tkinter import filedialog, messagebox
import itertools
import math

import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2Tk

from mechanism_check import (
    check_reachability_from_cartesian_points,
    global_points_from_parameters,
    load_input_from_yaml_strict,
)


class FitToolbar(NavigationToolbar2Tk):
    # Ersetzt den Home-Button-Tooltip/Funktion durch "Zoom to fit"
    toolitems = tuple(
        ("Zoom to fit", "Zoom to fit", image_file, callback)
        if text == "Home"
        else (text, tooltip_text, image_file, callback)
        for text, tooltip_text, image_file, callback in NavigationToolbar2Tk.toolitems
    )

    def __init__(self, canvas, window, ui):
        self.ui = ui
        super().__init__(canvas, window)

    def home(self, *args):
        self.ui.zoom_to_fit()


class MechanismUI:
    def __init__(self, root: tk.Tk):
        self.root = root
        self.root.title("QuadProber - Mechanismus UI")
        self.root.protocol("WM_DELETE_WINDOW", self._on_close)

        self.cfg = None
        self.ok = False
        self.solution = None
        self.diagnostics = None
        self.view_bounds = None
        self.param_vars = {
            "L": tk.StringVar(),
            "r1": tk.StringVar(),
            "r2": tk.StringVar(),
            "r3": tk.StringVar(),
            "r4": tk.StringVar(),
            "tol": tk.StringVar(),
        }
        self.target_point_vars = [
            (tk.StringVar(), tk.StringVar()),
            (tk.StringVar(), tk.StringVar()),
            (tk.StringVar(), tk.StringVar()),
            (tk.StringVar(), tk.StringVar()),
        ]

        top = tk.Frame(root)
        top.pack(side=tk.TOP, fill=tk.X, padx=8, pady=8)

        self.path_var = tk.StringVar()
        tk.Entry(top, textvariable=self.path_var, width=70).pack(side=tk.LEFT, padx=(0, 6))
        tk.Button(top, text="YAML laden", command=self.load_yaml).pack(side=tk.LEFT, padx=3)
        tk.Button(top, text="YAML speichern", command=self.save_yaml).pack(side=tk.LEFT, padx=3)
        tk.Button(top, text="Prüfen + Plot", command=self.run_check).pack(side=tk.LEFT, padx=3)

        param_frame = tk.LabelFrame(root, text="Live-Parameter")
        param_frame.pack(side=tk.TOP, fill=tk.X, padx=8, pady=(0, 8))

        param_specs = [
            ("L", "L"),
            ("r1", "r1"),
            ("r2", "r2"),
            ("r3", "r3"),
            ("r4", "r4"),
            ("tol", "tol"),
        ]

        for col, (key, label_text) in enumerate(param_specs):
            tk.Label(param_frame, text=label_text).grid(row=0, column=2 * col, padx=(6, 2), pady=6, sticky="e")
            entry = tk.Entry(param_frame, textvariable=self.param_vars[key], width=9)
            entry.grid(row=0, column=2 * col + 1, padx=(0, 4), pady=6, sticky="w")
            entry.bind("<Return>", lambda _e: self.apply_live_parameters())

        tk.Button(param_frame, text="Parameter übernehmen", command=self.apply_live_parameters).grid(
            row=0,
            column=2 * len(param_specs),
            padx=8,
            pady=6,
            sticky="w",
        )

        target_frame = tk.LabelFrame(root, text="Target Points (Live)")
        target_frame.pack(side=tk.TOP, fill=tk.X, padx=8, pady=(0, 8))

        for row, (x_var, y_var) in enumerate(self.target_point_vars):
            tk.Label(target_frame, text=f"P{row}").grid(row=row, column=0, padx=(6, 4), pady=4, sticky="e")
            tk.Label(target_frame, text="x").grid(row=row, column=1, padx=(2, 2), pady=4, sticky="e")
            x_entry = tk.Entry(target_frame, textvariable=x_var, width=10)
            x_entry.grid(row=row, column=2, padx=(0, 8), pady=4, sticky="w")
            tk.Label(target_frame, text="y").grid(row=row, column=3, padx=(2, 2), pady=4, sticky="e")
            y_entry = tk.Entry(target_frame, textvariable=y_var, width=10)
            y_entry.grid(row=row, column=4, padx=(0, 8), pady=4, sticky="w")

            x_entry.bind("<Return>", lambda _e: self.apply_target_points())
            y_entry.bind("<Return>", lambda _e: self.apply_target_points())

        tk.Button(target_frame, text="Target Points übernehmen", command=self.apply_target_points).grid(
            row=0,
            column=5,
            rowspan=4,
            padx=8,
            pady=4,
            sticky="nsw",
        )

        self.status_var = tk.StringVar(value="Bitte YAML laden.")
        tk.Label(root, textvariable=self.status_var, anchor="w").pack(fill=tk.X, padx=8)

        self.fig, self.ax = plt.subplots(figsize=(8, 6))
        self.canvas = FigureCanvasTkAgg(self.fig, master=root)
        self.canvas.get_tk_widget().pack(fill=tk.BOTH, expand=True)

        toolbar_frame = tk.Frame(root)
        toolbar_frame.pack(side=tk.BOTTOM, fill=tk.X)
        self.toolbar = FitToolbar(self.canvas, toolbar_frame, self)
        self.toolbar.update()

        self.canvas.mpl_connect("scroll_event", self._on_scroll)

        self._reset_plot()

    def _on_close(self):
        """Sauberer Shutdown, damit das Terminal nicht blockiert bleibt."""
        try:
            plt.close(self.fig)
            plt.close("all")
        except Exception:
            pass

        try:
            self.root.quit()
        except Exception:
            pass

        try:
            self.root.destroy()
        except Exception:
            pass

    def _on_scroll(self, event):
        """Mausrad-Zoom um den Cursorpunkt."""
        if event.inaxes != self.ax or event.xdata is None or event.ydata is None:
            return

        zoom_scale = 1.15
        if event.button == "up":
            scale = 1.0 / zoom_scale
        elif event.button == "down":
            scale = zoom_scale
        else:
            return

        x0, x1 = self.ax.get_xlim()
        y0, y1 = self.ax.get_ylim()
        cx, cy = event.xdata, event.ydata

        new_x0 = cx - (cx - x0) * scale
        new_x1 = cx + (x1 - cx) * scale
        new_y0 = cy - (cy - y0) * scale
        new_y1 = cy + (y1 - cy) * scale

        self.ax.set_xlim(new_x0, new_x1)
        self.ax.set_ylim(new_y0, new_y1)
        self.canvas.draw_idle()

    def _reset_plot(self):
        self.ax.clear()
        self.ax.set_title("2D Mechanismus")
        self.ax.set_xlabel("x")
        self.ax.set_ylabel("y")
        self.ax.grid(True, alpha=0.3)
        self.ax.axis("equal")
        self.canvas.draw()

    def _reset_view_bounds(self):
        self.view_bounds = [float("inf"), float("-inf"), float("inf"), float("-inf")]

    def _expand_bounds_point(self, x, y):
        if self.view_bounds is None:
            self._reset_view_bounds()
        self.view_bounds[0] = min(self.view_bounds[0], x)
        self.view_bounds[1] = max(self.view_bounds[1], x)
        self.view_bounds[2] = min(self.view_bounds[2], y)
        self.view_bounds[3] = max(self.view_bounds[3], y)

    def _expand_bounds_circle(self, x, y, r):
        self._expand_bounds_point(x - r, y - r)
        self._expand_bounds_point(x + r, y + r)

    def zoom_to_fit(self):
        if not self.view_bounds:
            return

        min_x, max_x, min_y, max_y = self.view_bounds
        if min_x == float("inf") or min_y == float("inf"):
            return

        dx = max_x - min_x
        dy = max_y - min_y
        if dx <= 0:
            dx = 1.0
        if dy <= 0:
            dy = 1.0

        margin = 0.08
        self.ax.set_xlim(min_x - dx * margin, max_x + dx * margin)
        self.ax.set_ylim(min_y - dy * margin, max_y + dy * margin)
        self.canvas.draw_idle()

    def load_yaml(self):
        path = filedialog.askopenfilename(
            title="YAML auswählen",
            filetypes=[("YAML files", "*.yaml;*.yml"), ("All files", "*.*")]
        )
        if not path:
            return
        try:
            self.cfg = load_input_from_yaml_strict(path)
            self.path_var.set(path)
            self.status_var.set("YAML geladen.")
            self._sync_live_parameter_fields()
            self._sync_target_point_fields()
            self.run_check()
        except Exception as e:
            messagebox.showerror("Fehler", f"YAML ungültig:\n{e}")

    def save_yaml(self):
        if not self.cfg:
            messagebox.showwarning("Hinweis", "Keine Konfiguration vorhanden. Bitte zuerst YAML laden.")
            return

        path = filedialog.asksaveasfilename(
            title="YAML speichern",
            defaultextension=".yaml",
            filetypes=[("YAML files", "*.yaml;*.yml"), ("All files", "*.*")]
        )
        if not path:
            return

        r1, r2 = self.cfg["left_radii"]
        r3, r4 = self.cfg["right_radii"]

        data = {
            "L": self.cfg["L"],
            "radii": {
                "left": [r1, r2],
                "right": [r3, r4],
            },
            "target_points": [list(p) for p in self.cfg["target_points"]],
            "tol": self.cfg["tol"],
            "verbose": self.cfg.get("verbose", True),
        }

        try:
            import yaml
            with open(path, "w", encoding="utf-8") as f:
                yaml.dump(data, f, default_flow_style=False, allow_unicode=True, sort_keys=False)
            self.path_var.set(path)
            self.status_var.set(f"YAML gespeichert: {path}")
        except Exception as e:
            messagebox.showerror("Fehler", f"Speichern fehlgeschlagen:\n{e}")

    def _sync_live_parameter_fields(self):
        if not self.cfg:
            return

        r1, r2 = self.cfg["left_radii"]
        r3, r4 = self.cfg["right_radii"]
        self.param_vars["L"].set(f"{self.cfg['L']:.6g}")
        self.param_vars["r1"].set(f"{r1:.6g}")
        self.param_vars["r2"].set(f"{r2:.6g}")
        self.param_vars["r3"].set(f"{r3:.6g}")
        self.param_vars["r4"].set(f"{r4:.6g}")
        self.param_vars["tol"].set(f"{self.cfg['tol']:.6g}")

    def _sync_target_point_fields(self):
        if not self.cfg:
            return

        points = self.cfg.get("target_points", [])
        if len(points) != 4:
            return

        for i, (x, y) in enumerate(points):
            x_var, y_var = self.target_point_vars[i]
            x_var.set(f"{x:.6g}")
            y_var.set(f"{y:.6g}")

    def apply_live_parameters(self):
        if not self.cfg:
            messagebox.showwarning("Hinweis", "Bitte zuerst YAML laden.")
            return

        try:
            L = float(self.param_vars["L"].get())
            r1 = float(self.param_vars["r1"].get())
            r2 = float(self.param_vars["r2"].get())
            r3 = float(self.param_vars["r3"].get())
            r4 = float(self.param_vars["r4"].get())
            tol = float(self.param_vars["tol"].get())
        except ValueError:
            messagebox.showerror("Fehler", "Parameter müssen gültige Zahlen sein.")
            return

        if min(L, r1, r2, r3, r4, tol) <= 0:
            messagebox.showerror("Fehler", "L, r1..r4 und tol müssen > 0 sein.")
            return

        self.cfg["L"] = L
        self.cfg["left_radii"] = (r1, r2)
        self.cfg["right_radii"] = (r3, r4)
        self.cfg["tol"] = tol
        self.status_var.set("Live-Parameter aktualisiert.")
        self.run_check()

    def apply_target_points(self):
        if not self.cfg:
            messagebox.showwarning("Hinweis", "Bitte zuerst YAML laden.")
            return

        new_points = []
        try:
            for x_var, y_var in self.target_point_vars:
                x = float(x_var.get())
                y = float(y_var.get())
                new_points.append((x, y))
        except ValueError:
            messagebox.showerror("Fehler", "Alle Target Point Felder müssen gültige Zahlen sein.")
            return

        self.cfg["target_points"] = new_points
        self.status_var.set("Target Points aktualisiert.")
        self.run_check()

    def run_check(self):
        if not self.cfg:
            messagebox.showwarning("Hinweis", "Bitte zuerst YAML laden.")
            return

        try:
            self.ok, self.solution, self.diagnostics = check_reachability_from_cartesian_points(
                target_points=self.cfg["target_points"],
                L=self.cfg["L"],
                left_radii=self.cfg["left_radii"],
                right_radii=self.cfg["right_radii"],
                tol=self.cfg["tol"],
                verbose=False,
            )
            self._plot_result()
        except Exception as e:
            messagebox.showerror("Fehler", f"Prüfung fehlgeschlagen:\n{e}")

    def _plot_result(self):
        self._reset_plot()
        self._reset_view_bounds()

        pts = self.cfg["target_points"]
        tol = self.cfg["tol"]
        r1, r2 = self.cfg["left_radii"]
        r3, r4 = self.cfg["right_radii"]

        # Zielpunkte
        target_color = "green" if self.ok else "red"
        target_label = "Zielpunkte (erreichbar)" if self.ok else "Zielpunkte (nicht erreichbar)"

        if self.ok:
            self.status_var.set("Ergebnis: TRUE")
        else:
            self.status_var.set("Ergebnis: FALSE")

        for i, (x, y) in enumerate(pts):
            self.ax.add_patch(
                plt.Circle(
                    (x, y),
                    tol,
                    fill=False,
                    edgecolor=target_color,
                    linewidth=1.8,
                    alpha=0.75,
                    zorder=5,
                )
            )
            self.ax.scatter([x], [y], c=target_color, s=22, zorder=6)
            self._expand_bounds_circle(x, y, tol)

        # Legenden-Handle für die Zielpunkte als Toleranzkreise
        self.ax.plot([], [], color=target_color, linewidth=1.8, label=f"{target_label}, r_tol={tol:.2g}")

        for i, (x, y) in enumerate(pts):
            self.ax.text(x + 0.05, y + 0.05, f"P{i}", fontsize=9)

        # Bei Lösung: Mechanismus zeichnen (blau)
        if self.ok and self.solution:
            L = self.cfg["L"]

            cL = self.solution["center_left"]
            cR = self.solution["center_right"]

            self.ax.scatter([cL[0], cR[0]], [cL[1], cR[1]], c="blue", s=80, label="Mittelpunkte", zorder=6)
            self.ax.plot([cL[0], cR[0]], [cL[1], cR[1]], "b--", label=f"Abstand L={L:.3f}")
            self._expand_bounds_point(cL[0], cL[1])
            self._expand_bounds_point(cR[0], cR[1])

            for center, rr in [(cL, r1), (cL, r2), (cR, r3), (cR, r4)]:
                self.ax.add_patch(plt.Circle(center, rr, fill=False, alpha=0.45, edgecolor="blue"))
                self._expand_bounds_circle(center[0], center[1], rr)

        # Bei keiner exakten Lösung: beste Annäherung anzeigen (orange)
        if (not self.ok) and self.diagnostics and self.diagnostics.get("best_candidate"):
            bc = self.diagnostics["best_candidate"]
            cL, cR = bc["cL"], bc["cR"]
            delta_L = bc.get("delta_L", 0)
            max_err = bc.get("max_point_error", 0)

            self.ax.scatter([cL[0], cR[0]], [cL[1], cR[1]], c="orange", s=70, label="Mittelpunkte (Annäherung)", zorder=6)
            self.ax.plot([cL[0], cR[0]], [cL[1], cR[1]], "orange", linestyle="--",
                         label=f"|cL-cR|={bc['dcr']:.3f} (Soll L={self.cfg['L']:.3f})")
            self._expand_bounds_point(cL[0], cL[1])
            self._expand_bounds_point(cR[0], cR[1])

            for center, rr in [(cL, r1), (cL, r2), (cR, r3), (cR, r4)]:
                self.ax.add_patch(
                    plt.Circle(center, rr, fill=False, alpha=0.55, linestyle="--", edgecolor="orange")
                )
                self._expand_bounds_circle(center[0], center[1], rr)

        self.ax.legend(loc="best")
        self.zoom_to_fit()
        self.canvas.draw()


if __name__ == "__main__":
    root = tk.Tk()
    root.geometry("1050x780")
    MechanismUI(root)
    root.mainloop()