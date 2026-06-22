extends Node2D

# Scenes used for spawning the idle model and the active spinner
var model_scene: PackedScene = preload("res://Spinner/spinnerModel.tscn")
var spinner_scene: PackedScene = preload("res://Spinner/spinnerMaster.tscn")

# Active instances
var current_model = null
var current_spinner = null
var idle_scene = null


# Finds the idle scene controller
func _ready():
	add_to_group("idleGameplay")

	var scenes = get_tree().get_nodes_in_group("idleScene")
	if scenes.size() > 0:
		idle_scene = scenes[0]


# Starts the round by spawning the idle model
func doStartRoundPressed() -> void:
	if current_model != null or current_spinner != null:
		return
	if idle_scene == null:
		return

	current_model = idle_scene.spawnModel(model_scene)

	$spin.visible = true
	$startRound.disabled = true


# Converts the model into a spinner and begins the spin phase
func doSpinPressed() -> void:
	if current_model == null:
		return

	$spin2.play()
	print("STARTING SPINNER SOUND")

	idle_scene.despawnModel()
	current_model = null

	current_spinner = idle_scene.spawnSpinner(spinner_scene)

	# Spinner setup
	current_spinner.setMaxHealth(20.0)
	current_spinner.setSpinSpeed(720.0)
	current_spinner.setStartSpeed(5.0)
	current_spinner.doSpin()

	$spin.visible = false


# Called when the spinner finishes its run
func resetRound():
	current_spinner = null
	$startRound.disabled = false


# Audio helpers
func stopSpinner():
	print("STOPPING SPINNER SOUND")
	$spin2.stop()

func playPing():
	$ping.play()
