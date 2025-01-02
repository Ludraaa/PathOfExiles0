extends Area2D
var mouse_pos

var damage
var speed_mult = 1
var type
var caster

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.play("swordsman")
	$Sprite.speed_scale = speed_mult
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Sprite.frame == 2:
		queue_free()
	if caster.CURR_STATE == caster.STATE.DYING:
		damage = 0
