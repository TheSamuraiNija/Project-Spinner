extends Control

@onready var bar: TextureProgressBar = $healthBar

func setup(max_health: float):
	bar.min_value = 0.0
	bar.max_value = 100.0
	bar.value = 100.0

func update_health(current_health: float, max_health: float):
	var percent: float = (current_health / max_health) * 100.0
	bar.value = clamp(percent, 0.0, 100.0)

func reset():
	bar.value = 100.0
