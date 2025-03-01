extends Path2D

@export var platform_scene: PackedScene

# Signal to spawn a platform
signal spawn_platform(progress: float)

func _on_platform_timer_timeout() -> void:
	var progress = 0.5
	# Select spawn position
	$PathFollow2D.progress_ratio = randf_range(0,1)
	# Create a platform instance and add it to the scene.
	var platform = platform_scene.instantiate()
	platform.position = $PathFollow2D.position
	platform.platform_speed = randf_range(200,400)
	add_child(platform)
