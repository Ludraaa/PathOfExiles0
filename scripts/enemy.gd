extends CharacterBody2D

enum STATE {IDLE, WALK, ATTACK, DYING}
var CURR_STATE : STATE
var flip_h = false

const speed = 50
var speed_mult

var attack_range = 20

var type = "skeleton"

var max_hitpoints = 10
var base_dmg = 5
var hitpoints

var aggro : bool = false
var can_aggro = false
var stun_timer : float = 0.0

var skill_1_slot = Skills.mob_melee_strike

func _ready() -> void:
	hitpoints = max_hitpoints
	$Healthbar.max_val = max_hitpoints
	speed_mult = randf_range(0.66, 1.0)

func _physics_process(delta: float) -> void:
	var direction : Vector2 = Vector2.ZERO
	direction = $NavigationAgent2D.get_next_path_position() - position
	direction = direction.normalized()
	velocity = direction * (speed * speed_mult)
	
	#Faces the sprite in the right direction
	if direction.x > 0.0:
		flip_h = false
	else:
		flip_h = true
	
	#update stun timer
	stun_timer -= delta
	
	#Updates the raycast to the player
	$PlayerCast.target_position = Globals.player.position - position
	
	#Update the healthbar
	$Healthbar.curr_val = hitpoints
	
	if CURR_STATE != STATE.DYING:
		if direction == Vector2(0, 0):
			CURR_STATE = STATE.IDLE
		else:
			CURR_STATE = STATE.WALK
		
		if position.distance_to(Globals.player.position) < attack_range:
			CURR_STATE = STATE.ATTACK
			attack()
			
		check_aggro()
		handle_death()
		if stun_timer <= 0:
			move_and_slide()
			handle_animation()
		
	if CURR_STATE == STATE.DYING and $Sprite.frame == 4:
		queue_free()

#Triggers the attack logic
func attack():
	if stun_timer <= 0.0:
		var skill1 = skill_1_slot.instantiate()
		skill1.caster = self
		skill1.target_pos = Globals.player.position
		get_parent().add_child(skill1)

#Aggros the mob if it sees the player
func check_aggro():
	if !aggro and can_aggro:
		if !$PlayerCast.is_colliding():
			_on_nav_timer_timeout()
			$NavTimer.start()
			aggro = true
			
func handle_animation():
	if CURR_STATE == STATE.IDLE and $Sprite.animation_finished:
		$Sprite.play(type + "_idle")
	if CURR_STATE == STATE.DYING and $Sprite.animation_finished:
		$Sprite.play(type + "_dying")
	if CURR_STATE == STATE.WALK and $Sprite.animation_finished:
		$Sprite.play(type + "_walk")
	if flip_h:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

func handle_death():
	if hitpoints <= 0 and CURR_STATE != STATE.DYING:
		CURR_STATE = STATE.DYING
		Globals.moused_over_objects.erase(self)
		$Hitbox/HitboxShape.disabled = true
		$Collision.disabled = true
		stun_timer = 0.0
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name != "Hitbox" and area.type == "player":
		hitpoints -= area.damage

func _on_hitbox_mouse_entered() -> void:
	Globals.moused_over_objects.append(self)


func _on_hitbox_mouse_exited() -> void:
	Globals.moused_over_objects.erase(self)


func _on_nav_timer_timeout() -> void:
	$NavigationAgent2D.target_position = Globals.player.position


func _on_aggro_start_timer_timeout() -> void:
	can_aggro = true
