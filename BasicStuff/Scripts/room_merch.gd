extends Node3D

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func on_door_exit2(body: Node3D) -> void:
	if body is player:
		$"../Player".position = $"../TrainRoom/tPP".global_position
		worldScript.roomsDone += 1
		$"../TrainRoom/TV/Label3D".text = "Stations\nPassed:\n" + str(worldScript.roomsDone)
