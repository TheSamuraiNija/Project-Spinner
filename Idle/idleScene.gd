extends Node3D

@onready var spawn_point = $spinnerSpawn

var current_model = null

func spawnModel(model_scene):
	var m = model_scene.instantiate()
	add_child(m)
	m.global_position = spawn_point.global_position
	current_model = m
	return m

func despawnModel():
	if current_model != null:
		current_model.queue_free()
		current_model = null

func spawnSpinner(spinner_scene):
	var s = spinner_scene.instantiate()
	add_child(s)
	s.global_position = spawn_point.global_position
	return s
