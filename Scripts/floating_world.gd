extends Node2D

signal game_started(disable_inputs: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_started.emit(true)
	$HUD.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_chord_timer_chord_timer_start() -> void:
	$"Music Player".play()
	

func _on_start_button_pressed() -> void:
	start_game()

func start_game():
	$HUD.hide()
	$"Platform Timer".start()
	$"Scrolling Background".scroll_time = 180
	$"Music Player".play()
	game_started.emit(false)
