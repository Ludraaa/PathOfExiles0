extends CharacterBody2D

var speed = 100.0
var direction : Vector2

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += speed * direction * delta
	
	if (direction != Vector2(0, 0)):
		if !$AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.play("idle")
	move_and_slide()
