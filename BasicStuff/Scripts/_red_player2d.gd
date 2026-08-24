extends CharacterBody2D

const SPEED = 500.0

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	velocity = Input.get_vector("left", "right", "forward", "backward") * SPEED
	
	
	move_and_slide()
