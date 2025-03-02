extends Node2D

@export var scroll_time: float = 5.0  # Time (in seconds) for the image to scroll normally
@export var rush_time: float = 1.5  # Constant time to rush back to the start position when the game ends

var start_pos
var end_pos
var current_tween : Tween = null  # Variable to hold the current tween reference

func _ready():
	pass

# Start the scrolling animation
func start_scroll():
	# If there is an existing tween, stop it
	if current_tween:
		current_tween.kill()

	# Create a new tween
	current_tween = get_tree().create_tween()
	current_tween.tween_property($Sprite2D, "position", end_pos, scroll_time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)

# Reset the scrolling by moving the sprite back to its initial position
func reset_scroll():
	# Reset the sprite's position and recalculate end position based on the image height
	$Sprite2D.position = start_pos
	var image_height = $Sprite2D.texture.get_height() * $Sprite2D.scale.y - 600
	end_pos = start_pos + Vector2(0, image_height)

# Rush the background back to the starting position in a constant time
func rush_back_to_start(time_to_start: float):
	# If there is an existing tween, stop it
	if current_tween:
		current_tween.kill()

	# Move the sprite back to the starting position in the constant rush_time
	current_tween = get_tree().create_tween()
	current_tween.tween_property($Sprite2D, "position", start_pos, time_to_start).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)

# Called when the game starts or when the scroll needs to start
func _on_floating_world_game_started(disable_inputs: bool) -> void:
	if disable_inputs:
		start_pos = $Sprite2D.position
		var image_height = $Sprite2D.texture.get_height() * $Sprite2D.scale.y - 600
		end_pos = start_pos + Vector2(0, image_height)
	else:
		start_scroll()


func _on_floating_world_game_end(is_win: bool) -> void:
	if !is_win:
		rush_back_to_start(rush_time)
