extends Node2D

var model_scene: PackedScene = preload("res://Spinner/spinnerModel.tscn")
var spinner_scene: PackedScene = preload("res://Spinner/spinnerMaster.tscn")

var current_model = null
var current_spinner = null
var idle_scene = null

func _ready():
	add_to_group("idleGameplay")
	var scenes = get_tree().get_nodes_in_group("idleScene")
	if scenes.size() > 0:
		idle_scene = scenes[0]

func _on_start_round_pressed() -> void:
	if current_model != null or current_spinner != null:
		return
	if idle_scene == null:
		return

	current_model = idle_scene.spawnModel(model_scene)

	$spin.visible = true
	$startRound.disabled = true

func _on_spin_pressed() -> void:
	if current_model == null:
		return

	idle_scene.despawnModel()
	current_model = null

	current_spinner = idle_scene.spawnSpinner(spinner_scene)

	current_spinner.setMaxHealth(100.0)
	current_spinner.setSpinSpeed(720.0)
	current_spinner.setStartSpeed(5.0)

	current_spinner.doSpin()

	$spin.visible = false

func resetRound():
	current_spinner = null
	$startRound.disabled = false
