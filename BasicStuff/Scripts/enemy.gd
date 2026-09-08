extends CharacterBody3D
class_name enemy

@onready var plr: player = $"../../../Player"
var attacking = false
var attackCD = 0.00

func _process(delta: float) -> void:
	if attacking:
		if attackCD <= 0.00:
			attackCD = 1.30
			plr.health -= 7
			velocity *= -1.3
	attackCD -= delta

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y -= 9.81 * delta
	var targetPos = plr.position
	var x = targetPos.x - global_position.x
	var z = targetPos.z - global_position.z	
	velocity = lerp(velocity, 4.2 * Vector3(x,0.0,z).normalized(), delta * 3)
	look_at(targetPos)
	rotation.z = 0
	rotation.x = 0
	move_and_slide()

func attack(body: Node3D) -> void:
	if body == plr:
		attacking = true

func stopAttack(body: Node3D) -> void:
	if body == plr:
		attacking = false
