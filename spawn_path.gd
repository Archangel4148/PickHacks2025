extends Path2D

@export var platform_scene: PackedScene

# Signal to spawn a platform
signal spawn_platform(progress: float)

func _on_platform_timer_timeout() -> void:
	print("Spawning")
	var progress = 0.5
	# Set the path follow to "progress" progress
	$PathFollow2D.progress_ratio = randf_range(0,1)
	# Create a platform instance and add it to the scene.
	var platform = platform_scene.instantiate()
	platform.position = $PathFollow2D.position
	add_child(platform)
