extends Node2D

signal game_started(disable_inputs: bool)
signal game_end(is_win: bool)

var game_length

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Win Screen".hide()
	$"Win HUD".hide()
	game_started.emit(true)
	$HUD.show()
	#game_length = $"Music Player".stream.get_length()
	game_length = 3
	
	# Initialize the ColorRect for the fade effect
	$"Fade Screen".color = Color(1, 1, 1, 0)
	$"Fade Screen".visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_chord_timer_chord_timer_start() -> void:
	$"Music Player".play()
	

func _on_start_button_pressed() -> void:
	start_game()

func start_game():
	game_started.emit(true)
	$HUD.hide()
	$"Win HUD".hide()
	$"Win Screen".hide()
	$"Platform Timer".start()
	# Set win timer
	$"Win Timer".wait_time = game_length
	# Set background scrolling speed
	if $"Music Player".stream:
		$"Scrolling Background".scroll_time = game_length
	else:
		$"Scrolling Background".scroll_time = 180
	$"Music Player".play()
	$"Win Timer".start()
	game_started.emit(false)

func game_over(is_win: bool):
	# Stop spawning platforms
	$"Platform Timer".stop()
	
	# Reset the music player
	$"Music Player".stop()
	if $"Music Player".stream:  # Ensure a valid audio stream exists
		$"Music Player".seek(0)  # Reset music to the start
	
	if is_win:
		game_end.emit(true)
		fade_to_white()
	else:
		game_end.emit(false)
		await get_tree().create_timer(3.5).timeout
		$HUD.show()
		game_started.emit(true)
	

func fade_to_white():
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property($"Fade Screen", "color:a", 1, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	await get_tree().create_timer(1.0).timeout
	# Set up and display the win screen (with the player)
	$"Win Screen".show()
	$"Starting Platform/CollisionShape2D".scale = Vector2($"Starting Platform/CollisionShape2D".scale.x * 5, $"Starting Platform/CollisionShape2D".scale.y)
	$Player.z_index = 10
	$Player.position = Vector2(200, 128)
	$Player.scale = Vector2(3,3)
	fade_tween = get_tree().create_tween()
	fade_tween.tween_property($"Fade Screen", "color:a", 0, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	await get_tree().create_timer(1.0).timeout
	$"Win HUD".show()

func _on_player_player_fell_out_of_bounds() -> void:
	game_over(false)

func _on_win_timer_timeout() -> void:
	game_over(true)

func _on_replay_button_pressed() -> void:
	# Hide win elements
	$"Win HUD".hide()
	$"Win Screen".hide()

	# Reset player properties
	$Player.position = Vector2(100, 500)  # Adjust to starting position
	$Player.scale = Vector2(1, 1)  # Reset scale
	$Player.z_index = 0  # Reset z-index if changed

	# Reset platform size if modified
	$"Starting Platform/CollisionShape2D".scale = Vector2(1, 1)

	# Reset background scrolling
	$"Scrolling Background".reset_scroll()

	# Clear all platforms
	$"SpawnPath".delete_all_platforms.emit()

	$Player.reset_player()
	$HUD.show()
