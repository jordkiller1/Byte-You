extends CharacterBody3D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 9.81 * delta
	var targetPos = $"../../../Player".position
	var x = targetPos.x - global_position.x
	var z = targetPos.z - global_position.z	
	velocity.x = x * 1.4
	velocity.z = z * 1.4
	targetPos = Vector3(targetPos.x,targetPos.y,targetPos.z)
	look_at(targetPos)
	rotation.z = 0
	rotation.x = 0
	move_and_slide()
