extends Path2D

@export var platform_scene: PackedScene

# Signal to spawn a platform
signal spawn_platform(progress: float)


func _on_chord_timer_send_chord_data(progress: float) -> void:
	# Select spawn position
	$PathFollow2D.progress_ratio = progress
	
	# Create a platform instance and add it to the scene.
	var platform = platform_scene.instantiate()
	platform.position = $PathFollow2D.position
	add_child(platform)
