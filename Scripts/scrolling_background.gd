extends Node2D

@export var scroll_time: float = 5.0  # Time (in seconds) for the image to scroll

var start_pos
var end_pos

func _ready():
	pass

func start_scroll():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "position", end_pos, scroll_time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)

func _on_floating_world_game_started(disable_inputs: bool) -> void:
	if disable_inputs:
		start_pos = $Sprite2D.position
		var image_height = $Sprite2D.texture.get_height() * $Sprite2D.scale.y - 600
		end_pos = start_pos + Vector2(0, image_height)
	else:
		start_scroll()
