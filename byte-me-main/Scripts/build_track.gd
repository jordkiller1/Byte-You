@tool
extends Node3D

## Run this once in the editor to build the curved rail geometry.
## Select this node and click "Build Track" in the inspector, or just
## attach it to the Track node – it runs _ready() in @tool mode.

@export var build_now: bool = false:
	set(v):
		if v and Engine.is_editor_hint():
			_build()

const RAIL_OFFSET   := 1.9    # half-gauge, metres from centre
const RAIL_W        := 0.18   # rail width
const RAIL_H        := 0.18   # rail height
const SEG_STEP      := 2.0    # metres between segments
const BED_W         := 4.5    # ballast bed half-width (full = 9 m)
const BED_H         := 0.22   # ballast height

# Smooth loop control points  [position, in-tangent, out-tangent]
# Same loop used by the Path3D nodes.
const POINTS := [
	[Vector3(  0, 0.15, -45), Vector3(-18,0,  0), Vector3( 18,0,   0)],
	[Vector3( 35, 0.15, -40), Vector3(-15,0,-10.5),Vector3(15,0, 10.5)],
	[Vector3( 50, 0.15, -10), Vector3(-1.5,0,-18), Vector3(1.5,0,  18)],
	[Vector3( 40, 0.15,  20), Vector3(  0,0,-16.5),Vector3( 0,0, 16.5)],
	[Vector3( 50, 0.15,  45), Vector3( 7.5,0,-11.4),Vector3(-7.5,0,11.4)],
	[Vector3( 15, 0.15,  58), Vector3( 21,0,  -3), Vector3(-21,0,   3)],
	[Vector3(-20, 0.15,  55), Vector3( 19.5,0,8.4),Vector3(-19.5,0,-8.4)],
	[Vector3(-50, 0.15,  30), Vector3( 7.5,0, 19.5),Vector3(-7.5,0,-19.5)],
	[Vector3(-45, 0.15, -10), Vector3(-7.5,0, 21), Vector3( 7.5,0, -21)],
	[Vector3(-25, 0.15, -40), Vector3(-13.5,0,10.5),Vector3(13.5,0,-10.5)],
]

func _ready() -> void:
	if Engine.is_editor_hint():
		_build()

func _build() -> void:
	# Remove old children except the Path3D helpers
	for ch in get_children():
		if ch.name in ["CenterPath","LeftPath","RightPath","Bed","RailL","RailR"]:
			ch.queue_free()
	await get_tree().process_frame

	var curve := Curve3D.new()
	curve.bake_interval = 0.5
	var n := POINTS.size()
	for i in n:
		curve.add_point(POINTS[i][0], POINTS[i][1], POINTS[i][2])
	# Close the loop by repeating the first point
	curve.add_point(POINTS[0][0], POINTS[0][1], POINTS[0][2])

	var pts: PackedVector3Array = curve.get_baked_points()

	# --- Ballast bed ---
	var bed_mat := StandardMaterial3D.new()
	bed_mat.albedo_color = Color(0.38, 0.32, 0.27)
	bed_mat.roughness = 0.95

	# --- Rail steel ---
	var rail_mat := StandardMaterial3D.new()
	rail_mat.albedo_color    = Color(0.55, 0.57, 0.60)
	rail_mat.metallic        = 0.85
	rail_mat.roughness       = 0.25

	var step := int(SEG_STEP / 0.5)  # every N baked points
	if step < 1: step = 1

	var i := 0
	while i < pts.size() - 1:
		var p0: Vector3 = pts[i]
		var p1: Vector3 = pts[min(i + step, pts.size() - 1)]
		var seg_len: float = p0.distance_to(p1)
		if seg_len < 0.01:
			i += step
			continue

		var fwd: Vector3 = (p1 - p0).normalized()
		var up  := Vector3.UP
		var right: Vector3 = fwd.cross(up).normalized()
		var mid: Vector3 = (p0 + p1) * 0.5

		var angle_y := atan2(-fwd.x, -fwd.z)   # yaw to face along fwd

		# Bed segment
		var bed := CSGBox3D.new()
		bed.name = "Bed_%d" % i
		bed.size = Vector3(BED_W * 2, BED_H, seg_len + 0.05)
		bed.position = mid
		bed.rotation = Vector3(0, angle_y, 0)
		bed.material = bed_mat
		add_child(bed)
		bed.owner = get_tree().edited_scene_root

		# Left rail
		var rl := CSGBox3D.new()
		rl.name = "RL_%d" % i
		rl.size = Vector3(RAIL_W, RAIL_H, seg_len + 0.05)
		rl.position = mid + right * RAIL_OFFSET + Vector3(0, BED_H * 0.5 + RAIL_H * 0.5, 0)
		rl.rotation = Vector3(0, angle_y, 0)
		rl.material = rail_mat
		add_child(rl)
		rl.owner = get_tree().edited_scene_root

		# Right rail
		var rr := CSGBox3D.new()
		rr.name = "RR_%d" % i
		rr.size = Vector3(RAIL_W, RAIL_H, seg_len + 0.05)
		rr.position = mid - right * RAIL_OFFSET + Vector3(0, BED_H * 0.5 + RAIL_H * 0.5, 0)
		rr.rotation = Vector3(0, angle_y, 0)
		rr.material = rail_mat
		add_child(rr)
		rr.owner = get_tree().edited_scene_root

		i += step

	print("Track built: ", pts.size(), " baked points → ", get_child_count(), " nodes")
