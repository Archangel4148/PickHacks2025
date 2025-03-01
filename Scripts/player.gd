extends CharacterBody2D

@export var move_speed = 300
@export var gravity = 30
@export var jump_force = 300
@export var max_jumps = 2

@export var crouch_scale: Vector2 = Vector2(1, 0.5)
@export var normal_scale: Vector2 = Vector2(1, 1)
@export var crouch_collision_size: Vector2 = Vector2(64, 32)

var jump_count = 0
var normal_collision_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the current size of the collision shape as the normal size
	normal_collision_size = $CollisionShape2D.shape.extents

func _process(delta: float) -> void:
	if Input.is_action_pressed("crouch"):
		$Sprite2D.scale = crouch_scale
		$CollisionShape2D.shape.extents = crouch_collision_size
	else:
		$Sprite2D.scale = normal_scale
		$CollisionShape2D.shape.extents = normal_collision_size

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		if jump_count == 0:
			jump_count = 1
		velocity.y += gravity
	
		if velocity.y > 1000:
			velocity.y = 1000
	else:
		jump_count = 0
		
	if jump_count < max_jumps and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force
		jump_count += 1
	
	var horiz_direction = Input.get_axis("move_left", "move_right")
	velocity.x = move_speed * horiz_direction
	move_and_slide()
