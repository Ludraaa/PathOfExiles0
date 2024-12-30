extends Node
class_name Skill

var mouse_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_pos = Globals.player.mouse_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
