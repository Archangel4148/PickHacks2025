extends AudioStreamPlayer

func _on_player_player_jumped(is_double_jump: bool) -> void:
	if !is_double_jump:
		play(0.01)
