extends CharacterBody3D

class_name player
var health = 100

var speed = 7
var friction = 0.85
var dashCD = 0
var pJump = 0
var multipliers = 1
var jCount = 0

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
		if pJump > 0 and pJump < 0.28:
			velocity.y = 4.5
			multipliers += 0.4
			jCount += 1
		elif is_on_floor():
			velocity.y = 4.5
			
		if is_on_wall_only():
			velocity = get_wall_normal() * 14
			velocity.y = 7
		pJump = 1
#--------
	if event.is_action_pressed("dash"):
		if dashCD <= 0:
			velocity.x *= speed
			velocity.z *= speed
			dashCD = 0.75
			health -= 30
#--------
	if event.is_action("reset"):
		position.x = 0
		position.y = 10
		position.z = 0
		velocity = Vector3(0,0,0)

func _process(delta: float) -> void:
	$Canvas/Panel/ColorRect.size.x = (245 * (health/100.00))
	$Canvas/Panel/ColorRect/Label.size.x = $Canvas/Panel/ColorRect.size.x
	$Canvas/Panel/ColorRect/Label.text = str(health)
	$Canvas/dbgLabel.text = str("%.2f" % pJump)
	$Canvas/dbgLabel3.text = "speed multiplier: " + str(multipliers)
	if health <= 0:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$Canvas/ded.visible = true

func endClick() -> void:
	get_tree().quit()

func restartClick() -> void:
	position.x = 0
	position.y = 10
	position.z = 0
	health = 100
	worldScript.roomsDone = 0
	velocity = Vector3(0,0,0)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Canvas/ded.visible = false


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
	var isJump
	if pJump > 0:
		pJump -= delta
		isJump = true
	if (pJump <= 0.0) and isJump:
		multipliers -= 0.4 * jCount
		jCount = 0
	
	var vel = Vector3(velocity.x,0,velocity.z)
	velTar *= multipliers
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
