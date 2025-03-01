extends RigidBody2D

var mob_types = ["allosaurus", "green_bird", "triceratops"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
