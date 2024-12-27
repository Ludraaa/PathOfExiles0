extends TileMapLayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.minimap_map = self

func sketch_map():
	for cell in Globals.curr_map.get_node("Map").get_used_cells():
		var poly : PackedVector2Array = Globals.curr_map.get_node("Map").get_cell_tile_data(cell).get_collision_polygon_points(0, 0)
		if poly.is_empty():
			set_cell(cell, 0, Vector2i(0, 0))
		else:
			set_cell(cell, 1, Vector2i(0, 0))

#Generates fog all over the map
func generate_fog():
	for x in range(Config.map_size_x):
		for y in range (Config.map_size_y):
			$Fog.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))

#Clears the fog in a radius around the player
func clear_fog():
	var player_tile_pos = Globals.curr_map.get_node("Map").local_to_map(Globals.player.position)
	for x in range(player_tile_pos.x - Config.fog_clear_radius, player_tile_pos.x + Config.fog_clear_radius + 1):
		for y in range(player_tile_pos.y - Config.fog_clear_radius, player_tile_pos.y + Config.fog_clear_radius + 1):
			if sqrt(((x -player_tile_pos.x) ** 2) + ((y - player_tile_pos.y) ** 2)) < Config.fog_clear_radius:
				$Fog.erase_cell(Vector2i(x, y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
