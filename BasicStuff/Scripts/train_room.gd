extends Node3D
var doorTP1
var doorTP2 
func _ready() -> void:
	roomRandom()
	
func onDoorTouch1(body: Node3D) -> void:
	if body is player:
		$"../Player".position = doorTP1
		roomRandom()

func onDoorTouch2(body: Node3D) -> void:
	if body is player:
		$"../Player".position = doorTP2
		roomRandom()

func roomRandom() -> void:
	for I in range(3):
		var roomID = randi_range(0, 4)
		match roomID:
			0:
				if I == 1:
					doorTP1 = $"../roomFight/Room/doorSpawn/tPP".global_position
					$doorChoice1/tv/scrText.text = "next stop:\n---------------\nFightroom"
				elif I == 2:
					doorTP2 = $"../roomFight/Room/doorSpawn/tPP".global_position
					$doorChoice2/tv/scrText.text = "next stop:\n---------------\nFightroom"
			1:
				if I == 1:
					doorTP1 = $"../roomPuzzle/Room/doorSpawn/tPP".global_position
					$doorChoice1/tv/scrText.text = "next stop:\n---------------\nPuzzleroom"
				elif I == 2:
					doorTP2 = $"../roomPuzzle/Room/doorSpawn/tPP".global_position
					$doorChoice2/tv/scrText.text = "next stop:\n---------------\nPuzzleroom"
			2:
				if I == 1:
					doorTP1 = $"../roomMerch/Room/doorSpawn/tPP".global_position
					$doorChoice1/tv/scrText.text = "next stop:\n---------------\nthe Merchant"
				elif I == 2:
					doorTP2 = $"../roomMerch/Room/doorSpawn/tPP".global_position
					$doorChoice2/tv/scrText.text = "next stop:\n---------------\nthe Merchant"
			3:
				if I == 1:
					doorTP1 = $"../roomParkour/Room/doorSpawn/tPP".global_position
					$doorChoice1/tv/scrText.text = "next stop:\n---------------\nParkour"
				elif I == 2:
					doorTP2 = $"../roomParkour/Room/doorSpawn/tPP".global_position
					$doorChoice2/tv/scrText.text = "next stop:\n---------------\nParkour"
			4:
				if I == 1:
					doorTP1 = $"../roomBoss/Room/doorSpawn/tPP".global_position
					$doorChoice1/tv/scrText.text = "next stop:\n---------------\nThe Boss"
				elif I == 2:
					doorTP2 = $"../roomBoss/Room/doorSpawn/tPP".global_position
					$doorChoice2/tv/scrText.text = "next stop:\n---------------\nThe Boss"
	if doorTP1 == doorTP2:
		roomRandom()
