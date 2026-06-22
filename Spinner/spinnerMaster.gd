extends Node3D

enum State { IDLE, SPIN, TOPPLE }

@export var max_health: float = 100.0
@export var health_drain_rate: float = 5.0
@export var spin_speed: float = 720.0
@export var start_speed: float = 5.0
@export var topple_spin_force: float = 4.0
@export var despawn_delay: float = 1.5
@export var bounce_strength: float = 25.0
@export var ray_distance: float = 0.3

var current_health: float
var state: State = State.IDLE
var pushed: bool = false
var ui = null
var rays: Array = []

@onready var model = $spinnerModel
@onready var spinner_body = $spinnerModel/spinnerBody

@onready var body = $spinnerCollision
@onready var base_collision = $spinnerCollision/baseCollision
@onready var topple_collision = $spinnerCollision/toppleCollision
@onready var topple_collision2 = $spinnerCollision/toppleCollision2

func _ready():
	current_health = max_health
	base_collision.disabled = true
	topple_collision.disabled = true
	topple_collision2.disabled = true

	var uis = get_tree().get_nodes_in_group("healthUI")
	if uis.size() > 0:
		ui = uis[0]
		ui.setup(max_health)

	_create_rays()

func _physics_process(delta):
	model.global_position = body.global_position

	if state != State.TOPPLE:
		_check_rays()

	match state:
		State.IDLE:
			pass

		State.SPIN:
			if not pushed:
				doInitialPush()

			spinner_body.rotation.x = 0
			spinner_body.rotation.z = 0
			spinner_body.rotate_y(deg_to_rad(spin_speed * delta))

			current_health -= health_drain_rate * delta

			if ui:
				ui.update_health(current_health, max_health)

			if current_health <= 0.0:
				doTopple()

		State.TOPPLE:
			model.global_rotation = body.global_rotation

func doIdle():
	state = State.IDLE
	body.freeze = true
	base_collision.disabled = true
	topple_collision.disabled = true
	topple_collision2.disabled = true
	_set_rays_enabled(true)

func doSpin():
	state = State.SPIN
	body.freeze = false
	base_collision.disabled = false
	topple_collision.disabled = true
	topple_collision2.disabled = true
	pushed = false
	_set_rays_enabled(true)

func doInitialPush():
	pushed = true
	body.apply_impulse(body.transform.basis.z * -start_speed)

func doTopple():
	state = State.TOPPLE
	body.freeze = false
	base_collision.disabled = true
	topple_collision.disabled = false
	topple_collision2.disabled = false
	_set_rays_enabled(false)
	body.apply_torque_impulse(Vector3(randf(), randf(), randf()) * topple_spin_force)
	endRun()

func endRun():
	await get_tree().create_timer(despawn_delay).timeout

	var gps = get_tree().get_nodes_in_group("idleGameplay")
	if gps.size() > 0:
		gps[0].resetRound()

	queue_free()

func setMaxHealth(v):
	max_health = v
	current_health = v

func setSpinSpeed(v):
	spin_speed = v

func setStartSpeed(v):
	start_speed = v

func getCurrentHealth():
	return current_health

func getMaxHealth():
	return max_health

func _create_rays():
	for i in range(16):
		var r = RayCast3D.new()
		var angle = deg_to_rad((360.0 / 16.0) * i)
		var dir = Vector3(cos(angle), 0, sin(angle))
		r.target_position = dir * ray_distance
		r.enabled = true
		model.add_child(r)
		rays.append(r)

func _set_rays_enabled(v):
	for r in rays:
		r.enabled = v

func _check_rays():
	for r in rays:
		if r.is_colliding():
			var normal = r.get_collision_normal()
			normal.y = 0
			normal = normal.normalized()
			var vel = body.linear_velocity
			var reflected = vel.bounce(normal)
			var extra = normal * bounce_strength
			body.linear_velocity = reflected + extra
