extends Node3D

func _ready() -> void:
	pass # Replace with function body.
	
func onDoorTouch1(body: Node3D) -> void:
	if body is player:
		$"../Player".position = $"../roomFight/Room/doorSpawn/tPP".global_position
	pass # Replace with function body.

func onDoorTouch2(body: Node3D) -> void:
	if body is player:
		$"../Player".position = $"../roomPuzzle/doorSpawn/tPP".global_position
	pass # Replace with function body.
