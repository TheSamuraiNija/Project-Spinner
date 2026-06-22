extends Control

# UI reference
@onready var bar: TextureProgressBar = $healthBar


# Initializes the bar to full based on a max health value
func setup(max_health: float):
	bar.min_value = 0.0
	bar.max_value = 100.0
	bar.value = 100.0


# Updates the bar using a percentage of current vs max health
func update_health(current_health: float, max_health: float):
	var percent: float = (current_health / max_health) * 100.0
	bar.value = clamp(percent, 0.0, 100.0)


# Resets the bar to full
func reset():
	bar.value = 100.0
