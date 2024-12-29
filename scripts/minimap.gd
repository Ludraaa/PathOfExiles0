extends ColorRect
var big_map : bool = false 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	switch_map()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$SubViewportContainer/SubViewport/player_marker.position = Globals.player.position
	if !big_map:
		$SubViewportContainer/SubViewport/Camera2D.position = Globals.player.position

func switch_map():
	if big_map:
		position = Vector2(-500, -1000)
		$SubViewportContainer.size = Vector2(350 * 6, 350 * 6)
		$SubViewportContainer/SubViewport/Camera2D.position = Vector2(Config.map_size_x, Config.map_size_y)
		$SubViewportContainer.modulate = Color(1, 1, 1, 0.7)
	else:
		position = Config.minimap_pos
		$SubViewportContainer/SubViewport/Camera2D.zoom = Config.minimap_zoom_factor
		$SubViewportContainer.size = Vector2(350, 350)
		$SubViewportContainer.modulate = Color(1, 1, 1, 0.3)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_minimap"):
		big_map = !big_map
		switch_map()
