extends TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.minimap_map = self

#Generates the minimap of the area surrounding the player
func generate_nearby():
	var player_tile_pos = Globals.curr_map.get_node("Map").local_to_map(Globals.player.position)
	for x in range(player_tile_pos.x - Config.fog_clear_radius, player_tile_pos.x + Config.fog_clear_radius + 0):
		for y in range(player_tile_pos.y - Config.fog_clear_radius, player_tile_pos.y + Config.fog_clear_radius + 0):
			if sqrt(((x -player_tile_pos.x) ** 2) + ((y - player_tile_pos.y) ** 2)) < Config.fog_clear_radius:
				if Globals.curr_map.get_node("Map").get_cell_atlas_coords(Vector2i(x, y)) != Vector2i(-1, -1):
					var poly_count = Globals.curr_map.get_node("Map").get_cell_tile_data(Vector2i(x, y)).get_collision_polygons_count(0)
					if poly_count == 0:
						set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
					else:
						set_cell(Vector2i(x, y), 1, Vector2i(0, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
