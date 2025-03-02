extends CharacterBody2D

@export var move_speed = 300
@export var gravity = 30
@export var jump_force = 300
@export var max_jumps = 2

var jump_count = 0  # Number of jumps that have been made
var disable_input = true
var game_is_over = false
var was_in_air = false  # Tracks if the player was airborne
var has_fallen = false

signal player_jumped(is_double_jump: bool)
signal player_landed  # Signal for landing detection
signal player_fell_out_of_bounds  # New signal for falling below the screen

@export var fall_threshold: float = 200  # How far below the screen before triggering the signal

# Store the spawn position
var spawn_position: Vector2
var original_scale: Vector2

func _ready():
	# Save the player's initial position as the spawn position when the game starts
	spawn_position = position
	original_scale = scale
	reset_player()  # Ensure the player starts in the initial position

func _physics_process(delta: float) -> void:
	var on_floor = is_on_floor()

	if !on_floor:
		# Expend a jump if walking off a platform
		if jump_count == 0:
			jump_count = 1

		# Apply gravity
		velocity.y += gravity

		# Cap falling speed
		velocity.y = min(velocity.y, 1000)

	else:
		# Reset jump count when landing
		jump_count = 0

		# Emit landing signal if the player was in the air
		if was_in_air:
			player_landed.emit()

	was_in_air = !on_floor  # Update air state
	
	if game_is_over:
		move_and_slide()
		if position.y > 500:
			position.y = 500
		return

	# Handle falling out of bounds
	var screen_bottom = get_viewport_rect().end.y  # Bottom of the viewport
	if position.y > screen_bottom + fall_threshold and !has_fallen:
		print("FALLING OUT OF THE WORLD")
		has_fallen = true
		player_fell_out_of_bounds.emit()

	if !disable_input:
		# Handle movement
		var horiz_direction = Input.get_axis("move_left", "move_right")
		velocity.x = move_speed * horiz_direction

		if on_floor:
			if horiz_direction == 1:
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("Run")
			elif horiz_direction == -1:
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("Run")
			else:
				$AnimatedSprite2D.play("Idle")
	else:
		$AnimatedSprite2D.play("Idle")

	move_and_slide()

func _input(event: InputEvent) -> void:
	if disable_input:
		return
		
	# Handle jumping
	if jump_count < max_jumps and event.is_action_pressed("jump"):
		velocity.y = -jump_force
		jump_count += 1
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("Jump")
		player_jumped.emit(!is_on_floor())

	# Handle crouching (dropping through platforms)
	if event.is_action_pressed("crouch"):
		set_collision_mask_value(10, false)
	else:
		set_collision_mask_value(10, true)

func _on_floating_world_game_started(disable_inputs: bool) -> void:
	disable_input = disable_inputs
	if disable_inputs:
		reset_player()

# Reset the player's state, position, and jump count
func reset_player():
	# Reset position and scale
	position = spawn_position
	scale = original_scale
	
	# Reset other state variables
	jump_count = 0
	velocity = Vector2.ZERO  # Reset velocity
	has_fallen = false
	was_in_air = false

	# Optionally reset animations
	$AnimatedSprite2D.play("Idle")  # Play idle animation when reset


func _on_floating_world_game_end(is_win: bool) -> void:
	if is_win:
		velocity.x = 0
		game_is_over = true
		disable_input = true
		
