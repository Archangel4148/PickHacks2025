extends Path2D

@export var platform_scene: PackedScene
@export var max_spawn_distance: float = 0.1
@export var scale_chance: float = 0.3  # Chance for platform to be smaller
@export var scale_factor_min: float = 0.5  # Smallest platform scale
@export var scale_factor_max: float = 0.8  # Largest smaller platform scale

# Signal to spawn a platform
signal spawn_platform(progress: float)

# Signal to delete all platforms
signal delete_all_platforms

func _ready():
	# Connect the signal to the function to delete all platforms
	delete_all_platforms.connect(_delete_all_platforms)

func _on_chord_timer_send_chord_data(progress: float) -> void:
	# Select spawn position based on given progress
	$PathFollow2D.progress_ratio = progress
	
	# Create a platform instance and add it to the scene.
	var platform = platform_scene.instantiate()
	platform.position = $PathFollow2D.position
	# Check if the platform should be scaled down
	if randf() < scale_chance:
		var scale_factor = randf_range(scale_factor_min, scale_factor_max)
		platform.scale = Vector2(scale_factor, 1)  # Scale only horizontally
	add_child(platform)

func _on_platform_timer_timeout() -> void:
	# Store the current progress as base
	var base_progress = $PathFollow2D.progress_ratio
	
	# Determine min and max for random offset from base_progress
	var min_value = clamp(base_progress - max_spawn_distance, 0, 1)
	var max_value = clamp(base_progress + max_spawn_distance, 0, 1)
	
	# Spawn the first platform: update progress and instantiate
	var new_progress = base_progress + randf_range(min_value, max_value)
	$PathFollow2D.progress_ratio = new_progress
	var platform = platform_scene.instantiate()
	platform.position = $PathFollow2D.position
	# Check if the platform should be scaled down
	if randf() < scale_chance:
		var scale_factor = randf_range(scale_factor_min, scale_factor_max)
		platform.scale = Vector2(scale_factor, 1)  # Scale only horizontally
	add_child(platform)
	
	# Spawn the second platform with a 25% chance
	if randf() < 0.25:
		# Generate an extra random progress based on the original base progress
		var extra_progress = base_progress + randf_range(min_value, max_value)
		while abs(extra_progress - base_progress) < 0.45:
			extra_progress += randf_range(min_value, max_value)
		extra_progress = clamp(extra_progress, 0, 1)
		
		# Save the current progress from the first platform spawn
		var temp_progress = $PathFollow2D.progress_ratio
		$PathFollow2D.progress_ratio = extra_progress
		var platform2 = platform_scene.instantiate()
		platform2.position = $PathFollow2D.position
		# Check if the second platform should be scaled down
		if randf() < scale_chance:
			var scale_factor = randf_range(scale_factor_min, scale_factor_max)
			platform2.scale = Vector2(scale_factor, 1)  # Scale only horizontally
		add_child(platform2)
		# Restore the progress after spawning the extra platform
		$PathFollow2D.progress_ratio = temp_progress

# Function to delete all platforms
func _delete_all_platforms():
	# Loop through the children and remove any that are platforms
	for child in get_children():
		if child is not PathFollow2D:
			child.queue_free()

func _on_floating_world_game_end(is_win: bool) -> void:
	delete_all_platforms.emit()
