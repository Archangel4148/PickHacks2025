extends StaticBody2D

var game_started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_player_jumped(is_double_jump: bool) -> void:
	if not game_started:
		return
	hide()
	set_collision_layer_value(1, false)

func _on_floating_world_game_started(disable_inputs: bool) -> void:
	if disable_inputs:
		game_started = false
		set_collision_layer_value(1, true)
		show()
	else:
		game_started = true
