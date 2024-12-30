extends CharacterBody2D

var speed = 100.0
var direction : Vector2
var mouse_pos

enum STATE {IDLE, WALK}
var CURR_STATE : STATE

var player_class = "swordsman"

var skill_1_slot

var stun_timer : float = 0.0

var cast_origin

var base_dmg = 5


func _ready() -> void:
	Globals.player = self
	skill_1_slot = Skills.melee_strike

func _physics_process(delta: float) -> void:
	mouse_pos = get_global_mouse_position()
	
	#Determines the origin of attacks and spells
	cast_origin = position + Vector2(0, -10)
	
	#Update the stuntimer and clamp it to a minimum value of 0
	stun_timer -= delta
	stun_timer = max(0.0, stun_timer)
	
	if stun_timer == 0.0:
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	else:
		direction = Vector2.ZERO
		
	velocity = speed * direction
	
	if direction == Vector2(0, 0):
		CURR_STATE = STATE.IDLE
	else:
		CURR_STATE = STATE.WALK
	move_and_slide()
	
	Globals.minimap_map.generate_nearby()
	if stun_timer == 0:
		handle_animations()
		
	use_skills()
	

func handle_facing():
	if mouse_pos.x > position.x:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true

func handle_animations():
	$Sprite.speed_scale = 1
	handle_facing()
	match CURR_STATE:
		STATE.IDLE:
			if !$Sprite.animation == "%s-idle" % [player_class] or $Sprite.animation_finished:
				$Sprite.play("%s-idle" % [player_class])
		STATE.WALK:
			if !$Sprite.animation == "%s-walk" % [player_class] or $Sprite.animation_finished:
				$Sprite.play("%s-walk" %[player_class])

func use_skills():
	if stun_timer == 0.0:
		if Input.is_action_pressed("skill_1"):
			var skill1 = skill_1_slot.instantiate()
			get_parent().add_child(skill1)
