extends Skill
var uses_animation = "1"
var tags = [Skills.SKILL_TAG.MELEE, Skills.SKILL_TAG.ATTACK]
var base_cast_time = 0.5
var remaining_cast_time

var damage_mult = 1.0
@onready var proj = preload("res://skills/projectiles/melee_strike_proj.tscn")

var gap_close_range = 100
var gap_close_gap = 25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	channel()

func channel():
	#Check if the player is hovering over something
	if !Globals.moused_over_objects.is_empty():
		var dist = Globals.get_closest_to_player(Globals.moused_over_objects).position.distance_to(Globals.player.position)
		if dist <= gap_close_range and dist >= gap_close_gap * 1.5:
			var angle = Globals.player.cast_origin.angle_to_point(mouse_pos)
			var vec = Vector2(cos(angle), sin(angle))
			Globals.player.position += vec * (dist - gap_close_gap)

	remaining_cast_time = base_cast_time
	Globals.player.get_node("Sprite").play(str(Globals.player.player_class) + "-attack" + uses_animation)
	Globals.player.get_node("Sprite").speed_scale = (6 / 5) / base_cast_time
	Globals.player.stun_timer += base_cast_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	remaining_cast_time -= delta
	if remaining_cast_time < 0.0:
		cast()
		queue_free()

func cast():
	var projectile = proj.instantiate()
	#Gets the position the projectile should be spawned at
	var angle = Globals.player.cast_origin.angle_to_point(mouse_pos)
	var vec = Vector2(cos(angle), sin(angle))
	projectile.position = Globals.player.cast_origin + vec * 15
	
	#Rotates the sprite based on the target location relative to the player
	if vec.x < 0:
		projectile.scale.x = -1
	if vec.y < 0:
		projectile.scale.y = -1

	projectile.damage = Globals.player.base_dmg * damage_mult
	get_parent().add_child(projectile)
