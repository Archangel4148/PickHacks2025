extends AnimatableBody2D

@export var platform_speed = 100
@export var direction: Vector2 = Vector2(-1, 0)  # Export direction as a Vector2
@onready var sprite = $Sprite2D  # Assuming you have a Sprite node as a child

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("I exist!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Calculate the velocity based on direction and speed
	var velocity = direction * platform_speed

	# Update the platform's position
	position += velocity * delta

	# Get the screen height
	var screen_height = get_viewport().size.y

	# Check if the platform has moved off the screen (left, right, or bottom)
	if position.x < -sprite.texture.get_width() or position.x > get_viewport().size.x + sprite.texture.get_width() or position.y > screen_height + sprite.texture.get_height():
		queue_free()  # Remove the platform when it leaves the screen
