extends Area2D
var mouse_pos

var damage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.play(Globals.player.player_class)
	$Sprite.speed_scale = 2
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Sprite.frame == 2:
		queue_free()
