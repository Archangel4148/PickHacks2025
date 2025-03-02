extends StaticBody2D

var game_started = false

@onready var despawn_timer = $"Despawn Timer"
@onready var sprite = $Sprite2D  # Adjust if your platform has a different node

var game_over = false

func _process(delta: float) -> void:
	if visible:
		set_collision_layer_value(1, true)
	else:
		set_collision_layer_value(1, false)
		print("NO COLLISION", randf())


# Called when the game starts
func _on_floating_world_game_started(disable_inputs: bool) -> void:
	if disable_inputs:
		game_started = false
		show()
		sprite.modulate = Color(1, 1, 1, 1)  # Reset transparency
	else:
		sprite.modulate = Color(1, 1, 1, 1)
		game_started = true
		despawn_timer.start()
		await get_tree().create_timer(3).timeout
		start_warning_effect()

# Called before the platform despawns
func start_warning_effect():
	var warning_tween = get_tree().create_tween()
	warning_tween.set_loops(5)  # Blinks 5 times before despawning
	warning_tween.tween_property(sprite, "modulate", Color(1, 0, 0, 1), 0.2)  # Turns red
	warning_tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.2)  # Turns back to normal

# Called when the despawn timer ends
func _on_despawn_timer_timeout() -> void:
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(sprite, "modulate:a", 0, 0.5)  # Fade out before hiding
	await fade_tween.finished
	hide()

func _on_floating_world_game_end(is_win: bool) -> void:
	game_over = true
