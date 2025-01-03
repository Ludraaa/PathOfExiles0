extends Node2D
var uses_animation = "1"
var tags = [Skills.SKILL_TAG.MELEE, Skills.SKILL_TAG.ATTACK]
var base_cast_time = 0.5
var skill_delay = 0.6 #0 is the end of cast time
var remaining_cast_time

var damage_mult = 1.0
@onready var proj = preload("res://skills/projectiles/melee_strike_proj.tscn")

var gap_close_range = 60
var gap_close_gap = 25

var caster
var target_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = caster.position - Vector2(0, 10)
	channel()

func channel():
	#Check if the player is hovering over something
	if !Globals.moused_over_objects.is_empty():
		var tar = Globals.get_closest_to_player(Globals.moused_over_objects)
		var tar_pos = tar.position
		var dist = tar_pos.distance_to(Globals.player.position)
		#Check if the player would skip a wall or prop
		Globals.player.get_node("RayCast").target_position = tar_pos - position
		var colliding : bool = Globals.player.get_node("RayCast").is_colliding()
		#Check if the player is close enough to the target
		if dist <= gap_close_range and dist >= gap_close_gap * 1.5 and !colliding:
			var angle = position.angle_to_point(target_pos)
			var vec = Vector2(cos(angle), sin(angle))
			caster.position += vec * (dist - gap_close_gap)
			position = caster.position

	remaining_cast_time = base_cast_time
	caster.get_node("Sprite").play(caster.type + "-attack" + uses_animation)
	caster.get_node("Sprite").speed_scale = (6 / 5) / base_cast_time
	caster.stun_timer = base_cast_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	remaining_cast_time -= delta
	if remaining_cast_time - (skill_delay * base_cast_time) < 0.0:
		cast()
		queue_free()

func cast():
	var projectile = proj.instantiate()
	#Gets the position the projectile should be spawned at
	var angle = position.angle_to_point(target_pos)
	var vec = Vector2(cos(angle), sin(angle))
	projectile.position = position + vec * 15
	
	#Rotates the sprite based on the target location relative to the player
	if vec.x < 0:
		projectile.scale.x = -1
	if vec.y < 0:
		projectile.scale.y = -1

	projectile.damage = caster.base_dmg * damage_mult
	projectile.type = "player"
	projectile.speed_mult = 2
	projectile.caster = caster
	get_parent().add_child(projectile)
