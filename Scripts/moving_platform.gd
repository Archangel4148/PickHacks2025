extends Path2D
class_name MovingPlatform

@export var path_time = 1.0
@export var looping = false
@export var ease: Tween.EaseType
@export var transition: Tween.TransitionType

func _ready() -> void:
	move_tween()


func move_tween():
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property($PathFollow2D, "progress_ratio", 1.0, path_time).set_ease(ease).set_trans(transition)
	if not looping:
		tween.tween_property($PathFollow2D, "progress_ratio", 0, path_time).set_ease(ease).set_trans(transition)
	else:
		tween.tween_property($PathFollow2D, "progress_ratio", 0, 0).set_ease(ease).set_trans(transition)
