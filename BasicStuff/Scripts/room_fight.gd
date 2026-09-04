extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_door_exit2(body: Node3D) -> void:
	if body is player:
		$"../Player".position = $"../TrainRoom/tPP".global_position
	pass # Replace with function body.
