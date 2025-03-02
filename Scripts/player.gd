extends CharacterBody2D

@export var move_speed = 300
@export var gravity = 30
@export var jump_force = 300
@export var max_jumps = 2

var jump_count = 0  # Number of jumps that have been made
var disable_input = true

signal player_jumped

func _ready():
	pass
	
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
		
	if !is_on_floor():
		# Expend a jump for walking off of platform edges
		if jump_count == 0:
			jump_count = 1
		
		# Apply gravity
		velocity.y += gravity
	
		# Velocity cap
		if velocity.y > 1000:
			velocity.y = 1000
	else:
		# Reset jump count on land
		jump_count = 0
	
	if !disable_input:
		# Handle directional movement
		var horiz_direction = Input.get_axis("move_left", "move_right")
		velocity.x = move_speed * horiz_direction


	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if disable_input:
		return
		
	# Handle jumping
	if jump_count < max_jumps and event.is_action_pressed("jump"):
		velocity.y = -jump_force
		jump_count += 1
		player_jumped.emit()
		
	# Handle crouching (dropping through platforms)
	if event.is_action_pressed("crouch"):
		set_collision_mask_value(10, false)
	else:
		set_collision_mask_value(10, true)
	


func _on_floating_world_game_started(disable_inputs: bool) -> void:
	disable_input = disable_inputs
