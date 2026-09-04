@tool
extends MultiMeshInstance3D

## Fills this MultiMesh with upright grass blades across the field,
## skipping circles around the indoor rooms so they stay clear.
@export var area_size: Vector2 = Vector2(180.0, 180.0)
@export var grass_count: int = 2800
@export var blade_width: float = 0.14
@export var blade_height: float = 0.55
@export var avoid_radius: float = 14.0
@export var station_avoid_radius: float = 22.0

const _AVOID: Array[Vector3] = [
	Vector3(-40.98, 0.0, -25.37),
	Vector3(-7.0, 0.0, -2.27),
	Vector3(25.89, 0.0, -22.38),
]
const _STATION := Vector3(8.0, 0.0, 27.27)

func _enter_tree() -> void:
	_scatter()

func _ready() -> void:
	if multimesh == null:
		_scatter()

func _scatter() -> void:
	var blade := QuadMesh.new()
	blade.size = Vector2(blade_width, blade_height)
	blade.center_offset = Vector3(0.0, blade_height * 0.5, 0.0)

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.32, 0.58, 0.2)
	mat.roughness = 0.92
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat.vertex_color_use_as_albedo = true
	mat.metallic = 0.0
	blade.material = mat

	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.use_colors = true
	mm.mesh = blade
	mm.instance_count = grass_count

	var rng := RandomNumberGenerator.new()
	rng.seed = 20260904

	var placed := 0
	var attempts := 0
	var max_attempts := grass_count * 10
	while placed < grass_count and attempts < max_attempts:
		attempts += 1
		var x := rng.randf_range(-area_size.x * 0.5, area_size.x * 0.5)
		var z := rng.randf_range(-area_size.y * 0.5, area_size.y * 0.5)
		var p := Vector3(x, 0.02, z)
		if _blocked(p):
			continue
		var xf := Transform3D.IDENTITY
		xf = xf.rotated(Vector3.UP, rng.randf() * TAU)
		var h := rng.randf_range(0.65, 1.45)
		xf = xf.scaled(Vector3(rng.randf_range(0.8, 1.25), h, 1.0))
		xf.origin = p
		mm.set_instance_transform(placed, xf)
		mm.set_instance_color(
			placed,
			Color(0.2, 0.42, 0.12).lerp(Color(0.48, 0.72, 0.22), rng.randf())
		)
		placed += 1

	mm.visible_instance_count = placed
	multimesh = mm

func _blocked(p: Vector3) -> bool:
	for c in _AVOID:
		if Vector2(p.x - c.x, p.z - c.z).length() < avoid_radius:
			return true
	if Vector2(p.x - _STATION.x, p.z - _STATION.z).length() < station_avoid_radius:
		return true
	return false
