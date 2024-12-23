extends CharacterBody2D

var speed = 1000.0
var direction : Vector2

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += speed * direction * delta
	move_and_slide()
