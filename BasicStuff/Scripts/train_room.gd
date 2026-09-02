extends Node3D

func _ready() -> void:
	pass # Replace with function body.

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is player:
		#$"../Environment/DirectionalLight3D".visible = false
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
		#$"../Player/Canvas/MarginContainer/HBoxContainer".visible = true
		$"../Player".position = $tPP.global_position
		$"../Player".velocity = Vector3(0,0,0)
		

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is player:
		#$"../Environment/DirectionalLight3D".visible = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		$"../Player/Canvas/MarginContainer/HBoxContainer".visible = false
	

func onDoorTouch1(body: Node3D) -> void:
	if body is player:
		$"../Player".position = $"../roomFight/doorSpawn/tPP".global_position
	pass # Replace with function body.

func onDoorTouch2(body: Node3D) -> void:
	pass # Replace with function body.
