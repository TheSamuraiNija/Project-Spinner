extends Node3D

# Spawn location for models and spinners
@onready var spawn_point = $spinnerSpawn

# Tracks the currently spawned idle model
var current_model = null


# Spawns the idle model at the spawn point
func spawnModel(model_scene):
	var m = model_scene.instantiate()
	add_child(m)
	m.global_position = spawn_point.global_position
	current_model = m
	return m


# Removes the idle model if one exists
func despawnModel():
	if current_model != null:
		current_model.queue_free()
		current_model = null


# Spawns the active spinner at the spawn point
func spawnSpinner(spinner_scene):
	var s = spinner_scene.instantiate()
	add_child(s)
	s.global_position = spawn_point.global_position
	return s
