extends AudioStreamPlayer

@export var jump_sounds: Array[AudioStream] = []  # Assign multiple jump sounds in the Inspector

func _on_player_player_jumped(is_double_jump: bool) -> void:
	if !is_double_jump and jump_sounds.size() > 0:
		stream = jump_sounds[randi() % jump_sounds.size()]  # Pick a random sound
		play(0.03)
