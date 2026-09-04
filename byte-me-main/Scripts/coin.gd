extends Area3D
var touching : bool = false

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	#$"..".rotation_degrees.y += 60 * delta
	if touching:
		$"..".position.y += 10 * delta
	elif $"..".position.y > 0:
		$"..".position.y -= 20 * delta
func _on_body_entered(body: Node3D) -> void:
	if body is player:
		touching = true

func _on_body_exited(body: Node3D) -> void:
	if body is player:
		touching = false
