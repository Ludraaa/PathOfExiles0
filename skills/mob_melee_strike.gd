extends Node2D
var uses_animation = "1"
var tags = [Skills.SKILL_TAG.MELEE, Skills.SKILL_TAG.ATTACK]
var base_cast_time = 1.0
var skill_delay = 0.4 #0 is the end of cast time
var remaining_cast_time

var damage_mult = 1.0
@onready var proj = preload("res://skills/projectiles/melee_strike_proj.tscn")

var caster
var target_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = caster.position
	channel()

func channel():
	remaining_cast_time = base_cast_time
	caster.get_node("Sprite").play(caster.type + "_attack" + uses_animation)
	caster.get_node("Sprite").speed_scale = (6 / 5) / base_cast_time
	caster.stun_timer = base_cast_time * 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	remaining_cast_time -= delta
	if remaining_cast_time - (skill_delay * base_cast_time) < 0.0:
		cast()
		queue_free()
	if !caster:
		queue_free()

func cast():
	var projectile = proj.instantiate()
	#Gets the position the projectile should be spawned at
	var angle = position.angle_to_point(target_pos)
	var vec = Vector2(cos(angle), sin(angle))
	projectile.position = position + vec * 5
	
	#Rotates the sprite based on the target location relative to the player
	if vec.x < 0:
		projectile.scale.x = -1
	if vec.y < 0:
		projectile.scale.y = -1
	projectile.scale *= Vector2(0.5, 0.5)
	projectile.damage = caster.base_dmg * damage_mult
	projectile.type = "mob"
	projectile.speed_mult = 10
	projectile.caster = caster
	get_parent().add_child(projectile)
