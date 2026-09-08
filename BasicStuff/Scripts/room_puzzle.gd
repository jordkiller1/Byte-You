extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_door_touch_exit1(body: Node3D) -> void:
	if body is player:
		$"../Player".position = $"../TrainRoom/tPP".global_position
		worldScript.roomsDone += 1
		$"../TrainRoom/TV/Label3D".text = "Stations\nPassed:\n" + str(worldScript.roomsDone)
	pass # Replace with function body.
