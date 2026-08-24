extends Control

func _on_btn_host_pressed() -> void:
	NetworkController.start_server()
	
	
	


func _on_btn_join_pressed() -> void:
	NetworkController.start_client()
	
