extends Control

# Loads the idle gameplay scene when the start button is pressed
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/idleGameplay/idleGameplay.tscn")
