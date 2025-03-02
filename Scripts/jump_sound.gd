extends AudioStreamPlayer2D

@onready var jump_sound = preload("res://sound effects/grunts/grunt1.wav")  # Preload the sound

func _on_player_player_jumped(is_double_jump: bool) -> void:
	if !is_double_jump:
		stream = jump_sound
		play(0.2)
