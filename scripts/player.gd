extends CharacterBody2D

var speed = 100.0
var direction : Vector2

enum STATE {IDLE, WALK}
var CURR_STATE : STATE

var player_class = "swordsman"

var mouse_pos

func _ready() -> void:
	Globals.player = self

func _physics_process(delta: float) -> void:
	mouse_pos = get_global_mouse_position()
	
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = speed * direction
	
	if direction == Vector2(0, 0):
		CURR_STATE = STATE.IDLE
	else:
		CURR_STATE = STATE.WALK
	move_and_slide()
	
	Globals.minimap_map.generate_nearby()
	handle_animations()

func handle_facing():
	if mouse_pos.x > position.x:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true

func handle_animations():
	handle_facing()
	match CURR_STATE:
		STATE.IDLE:
			if !$Sprite.animation == "%s-idle" % [player_class] or $Sprite.animation_finished:
				$Sprite.play("%s-idle" % [player_class])
		STATE.WALK:
			if !$Sprite.animation == "%s-walk" % [player_class] or $Sprite.animation_finished:
				$Sprite.play("%s-walk" %[player_class])
