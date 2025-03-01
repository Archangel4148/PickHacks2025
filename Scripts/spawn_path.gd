extends Path2D

@export var platform_scene: PackedScene
@export var max_spawn_distance: float = 0.1

# Signal to spawn a platform
signal spawn_platform(progress: float)


func _on_chord_timer_send_chord_data(progress: float) -> void:
	# Select spawn position
	$PathFollow2D.progress_ratio = progress
	
	# Create a platform instance and add it to the scene.
	var platform = platform_scene.instantiate()
	platform.position = $PathFollow2D.position
	add_child(platform)


func _on_platform_timer_timeout() -> void:
	var current_progress = $PathFollow2D.progress_ratio
	var min = clamp(current_progress - max_spawn_distance, 0, 1)
	var max = clamp(current_progress + max_spawn_distance, 0, 1)
	$PathFollow2D.progress_ratio = current_progress + randf_range(min, max)
	# Create a platform instance and add it to the scene.
	var platform = platform_scene.instantiate()
	platform.position = $PathFollow2D.position
	add_child(platform)
