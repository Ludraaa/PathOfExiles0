extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$SubViewportContainer/SubViewport/player_marker.position = Globals.player.position
	$SubViewportContainer/SubViewport/Camera2D.position = Globals.player.position
