extends AudioStreamPlayer



func _on_player_player_fell_out_of_bounds() -> void:
	play(0.05)
