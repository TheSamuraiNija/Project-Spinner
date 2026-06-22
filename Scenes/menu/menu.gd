extends Control

func _on_start_button_pressed() -> void:
	AudioPlayer.get_node("ButtonPress").play()
	get_tree().change_scene_to_file("res://Scenes/idleGameplay/idleGameplay.tscn")
