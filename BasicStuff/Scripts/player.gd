extends CharacterBody3D

class_name player
var speed = 7
var friction = 0.85
var dashCD = 0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED	


func _input(event: InputEvent) -> void:	
#--------
	if event.is_action_pressed("esc"):
		get_tree().quit()
#--------
	if event.is_action("ui_up"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action("ui_down"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#--------
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation_degrees.y -= event.relative.x
		$Camera.rotation_degrees.x -= event.relative.y
		if $Camera.rotation_degrees.x > 90:
			$Camera.rotation_degrees.x = 90
		if $Camera.rotation_degrees.x < -90:
			$Camera.rotation_degrees.x = -90
#--------
	if event.is_action_pressed("jump"):
		if is_on_floor():
			velocity.y = 4.5
		if is_on_wall_only():
			velocity = get_wall_normal() * 14
			velocity.y = 7
#--------
	if event.is_action_pressed("dash"):
		if dashCD <= 0:
			velocity.x *= speed
			velocity.z *= speed
			dashCD = 0.75
#--------
	if event.is_action("reset"):
		position.x = 0
		position.y = 10
		position.z = 0


func _physics_process(delta: float) -> void:
	var inVec :=  Input.get_vector("left","right","forward","backward")		
	var dir := transform.basis * Vector3(inVec.x,0,inVec.y).normalized()
	var velTar
	if not is_on_floor():
		velTar = dir * speed * 0.60
	else:
		velTar = dir * speed
		
	if dashCD > 0:
		dashCD -= delta
	
	var vel = Vector3(velocity.x,0,velocity.z)
	if dir:
		vel = vel.lerp(velTar, speed * delta)
	elif is_on_floor():
		vel = vel.lerp(Vector3.ZERO, friction)
	velocity.x = vel.x
	velocity.z = vel.z

	if not is_on_floor():
		if is_on_wall() and velocity.y < 0:
			velocity.y -= 9.81 * delta * 0.1
		else:
			velocity.y -= 9.81 * delta
	move_and_slide()
