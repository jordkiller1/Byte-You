extends Node3D

func _ready() -> void:
	pass # Replace with function body.

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is player:
		$"../Environment/DirectionalLight3D".visible = false
		pass # Replace with function body.

func _on_area_3d_body_exited(body: Node3D) -> void:
	$"../Environment/DirectionalLight3D".visible = true
	pass # Replace with function body.
