# Godot 4 — Coin Run Starter

## How to use
1. Open the folder as a Godot project (project.godot included).
2. Open `scenes/Main.tscn`.
3. In `Main`, add:
   - Platforms: add `StaticBody3D` + `CollisionShape3D` (Box) under `Platforms`.
   - Coin: add a `Area3D` + `CollisionShape3D` (Sphere/Box) + Mesh under `Coins`.
   - Connect coin `body_entered` → Main to increment a score variable and `queue_free()` the coin.
4. Press Play. Move with arrow keys/WASD, jump with Enter/Space (mapped to `ui_accept`).

## Notes
- `Player.gd` already moves/jumps. You add scoring & goal logic in Main or a separate script.
- Import `.glb` models into `res://models/` and instance them under `Platforms`/`Coins`.
