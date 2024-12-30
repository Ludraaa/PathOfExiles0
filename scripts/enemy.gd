extends CharacterBody2D

enum STATE {IDLE, WALK, ATTACK, DYING}
var CURR_STATE : STATE

const speed = 300.0

var type = "skeleton"

var max_hitpoints = 10
var hitpoints

func _ready() -> void:
	hitpoints = max_hitpoints
	$Healthbar.max_val = max_hitpoints

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	
	if direction == Vector2(0, 0):
		CURR_STATE = STATE.IDLE
	else:
		CURR_STATE = STATE.WALK
	
	velocity = direction * speed
	
	#Update the healthbar
	$Healthbar.curr_val = hitpoints
	
	if CURR_STATE != STATE.DYING:
		move_and_slide()
		handle_death()
		handle_animation()
	if CURR_STATE == STATE.DYING and $Sprite.frame == 4:
		queue_free()
	
func handle_animation():
	if CURR_STATE == STATE.IDLE and $Sprite.animation_finished:
		$Sprite.play(type + "_idle")
	if CURR_STATE == STATE.DYING and $Sprite.animation_finished:
		$Sprite.play("skeleton_dying")

func handle_death():
	if hitpoints <= 0 and CURR_STATE != STATE.DYING:
		CURR_STATE = STATE.DYING
		Globals.moused_over_objects.erase(self)
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name != "Hitbox":
		hitpoints -= area.damage

func _on_hitbox_mouse_entered() -> void:
	Globals.moused_over_objects.append(self)


func _on_hitbox_mouse_exited() -> void:
	Globals.moused_over_objects.erase(self)
