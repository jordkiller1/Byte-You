@tool
extends Node3D

@export var scatter_now: bool = false:
	set(v):
		if v and Engine.is_editor_hint():
			_scatter()

# Points just outside the track loop (offset ~8-12 units from centre path)
const TREE_POSITIONS := [
	Vector3(  5, 0, -56),   Vector3( 22, 0, -55),  Vector3( 40, 0, -52),
	Vector3( 58, 0, -32),   Vector3( 62, 0, -10),   Vector3( 62, 0, 10),
	Vector3( 56, 0, 32),    Vector3( 60, 0, 52),     Vector3( 35, 0, 62),
	Vector3( 12, 0, 68),    Vector3(-10, 0, 66),     Vector3(-30, 0, 63),
	Vector3(-55, 0, 38),    Vector3(-60, 0, 12),     Vector3(-60, 0,-12),
	Vector3(-56, 0,-30),    Vector3(-38, 0,-50),     Vector3(-16, 0,-56),
	# Second ring slightly tighter – inner side of track
	Vector3(  5, 0, -35),   Vector3( 25, 0, -32),
	Vector3( 32, 0,  10),   Vector3( 28, 0,  35),
	Vector3(  5, 0,  48),   Vector3(-18, 0,  46),
	Vector3(-36, 0,  20),   Vector3(-36, 0,  -8),
	Vector3(-22, 0, -32),
]

const GRASS_POSITIONS := [
	Vector3(  12, 0, -50),  Vector3(-12, 0, -50),
	Vector3(  50, 0, -20),  Vector3(  50, 0,  20),
	Vector3(  25, 0,  55),  Vector3( -5, 0,  57),
	Vector3( -25, 0, 55),   Vector3( -52, 0, 25),
	Vector3( -50, 0, -5),   Vector3( -30, 0,-45),
	Vector3(   0, 0, -40),  Vector3(  35, 0,  -5),
	Vector3(  12, 0,  40),  Vector3( -12, 0,  40),
]

func _ready() -> void:
	if Engine.is_editor_hint():
		_scatter()

func _scatter() -> void:
	# Remove previously scattered children
	for ch in get_children():
		ch.queue_free()
	await get_tree().process_frame

	var trunk_mat := StandardMaterial3D.new()
	trunk_mat.albedo_color = Color(0.36, 0.25, 0.15)
	trunk_mat.roughness = 0.95

	var canopy_mat := StandardMaterial3D.new()
	canopy_mat.albedo_color = Color(0.18, 0.55, 0.18)
	canopy_mat.roughness = 0.85

	var grass_mat := StandardMaterial3D.new()
	grass_mat.albedo_color = Color(0.22, 0.65, 0.15)
	grass_mat.roughness = 0.9

	var rng := RandomNumberGenerator.new()
	rng.seed = 42

	# --- Trees ---
	for i in TREE_POSITIONS.size():
		var base: Vector3 = TREE_POSITIONS[i]
		var jitter := Vector3(rng.randf_range(-2,2), 0, rng.randf_range(-2,2))
		var pos: Vector3 = base + jitter
		var scale_f := rng.randf_range(0.8, 1.4)
		var h := 3.6 * scale_f

		var trunk := CSGCylinder3D.new()
		trunk.name = "STree_%d" % i
		trunk.radius = 0.28 * scale_f
		trunk.height = h
		trunk.position = Vector3(pos.x, h * 0.5, pos.z)
		trunk.material = trunk_mat
		add_child(trunk)
		trunk.owner = get_tree().edited_scene_root

		for c in range(3):
			var sph := CSGSphere3D.new()
			sph.name = "SC_%d_%d" % [i, c]
			sph.radius = rng.randf_range(1.2, 1.8) * scale_f
			sph.position = Vector3(
				rng.randf_range(-0.4, 0.4),
				h * 0.5 + rng.randf_range(0.0, 0.8),
				rng.randf_range(-0.4, 0.4)
			)
			sph.material = canopy_mat
			trunk.add_child(sph)
			sph.owner = get_tree().edited_scene_root

	# --- Grass patches ---
	for i in GRASS_POSITIONS.size():
		var base: Vector3 = GRASS_POSITIONS[i]
		var jitter := Vector3(rng.randf_range(-3,3), 0, rng.randf_range(-3,3))
		var pos: Vector3 = base + jitter
		var w := rng.randf_range(3.5, 7.0)
		var d := rng.randf_range(3.5, 7.0)

		var patch := CSGBox3D.new()
		patch.name = "Grass_%d" % i
		patch.size = Vector3(w, 0.08, d)
		patch.position = Vector3(pos.x, 0.04, pos.z)
		patch.material = grass_mat
		add_child(patch)
		patch.owner = get_tree().edited_scene_root

	print("Scattered %d trees and %d grass patches" % [TREE_POSITIONS.size(), GRASS_POSITIONS.size()])
