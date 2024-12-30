extends Node2D

#Array containing all special rooms that should be in the map
var rooms = []

#Tilemap positions of left,right,up,down-facing connectors
var open_connectors = [[],[],[],[]]

#Array of all filler rooms to be useable
var room_lib = []

#Positions of all blocked spaces, where no room can cut in to
var blocked = []

#Keeps track of the number of rooms currently
var filler_count = 0


#Position of the spawn tile
var spawn_location : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assemble_room_lib()
	generate_map()

var weights = [
	1,#corridor_h
	1,#corridor_v
	1,#corner_lu
	1,#corner_ru
	1,#corner_ld
	1,#corner_rd
	1,#tjunktion_l
	1,#tjunktion_r
	1,#tjunktion_u
	1,#tjunktion_d
	1,#four_way
	3,#complex_a
	3,#complex_b
	3,#complex_c
]

#Gathers all the possible filler rooms into the array
func assemble_room_lib():
	room_lib.append(Constants.corridor_h_arr)
	room_lib.append(Constants.corridor_v_arr)
	room_lib.append(Constants.corner_lu_arr)
	room_lib.append(Constants.corner_ru_arr)
	room_lib.append(Constants.corner_ld_arr)
	room_lib.append(Constants.corner_rd_arr)
	room_lib.append(Constants.tjunktion_l_arr)
	room_lib.append(Constants.tjunktion_r_arr)
	room_lib.append(Constants.tjunktion_u_arr)
	room_lib.append(Constants.tjunktion_d_arr)
	room_lib.append(Constants.four_way_arr)
	
	room_lib.append(Constants.complex_a_arr)
	room_lib.append(Constants.complex_b_arr)
	room_lib.append(Constants.complex_c_arr)

#Selects a random room from the room_lib and checks for a possible connection, as well as blocked tiles
func select_random_filler(connection, anchor):
	var attempts = 5

	#Tries to find a matching room for the selected connector
	for attempt in range(attempts):
		var room = Globals.random_entry(Globals.random_entry(room_lib, weights)).instantiate()
		room.init()
		if len(room.anchors[Constants.invConnectionTypeList[connection]]) > 0:
			#Select a random connection in the correct direction and check for collision with other rooms
			var random_connector = Globals.random_entry(room.anchors[Constants.invConnectionTypeList[connection]])
			if check_blocked(room, random_connector, anchor):
				return [room, random_connector]
	return []
	
#Checks if the given room would collide with any existing rooms
func check_blocked(room, anchor, pos):
	for x in range(pos.x - anchor.x, pos.x - anchor.x + room.size_x):
		for y in range(pos.y - anchor.y, pos.y - anchor.y + room.size_y):
			if Vector2i(x, y) in blocked or x > Config.map_size_x or y > Config.map_size_y or x < 0 or y < 0:
				return false
	return true

#Selects a random connection type
func select_connection():
	#Choose a random connection type 
	var connection_type = Globals.random_entry(Constants.ConnectionTypeList)
	return connection_type

#Selects the closest connection from spawn, with a chance to take a random one
func select_connector(connection_type):
	#Choose a random connector with exploration
	var pos_r = randi_range(1, 10)
	var connector
	if pos_r > 5:
		#Selects a random connector of the given direction
		if (len(open_connectors[connection_type]) < 1):
			return Vector2i(-1, -1)
		connector = Globals.random_entry(open_connectors[connection_type])
	else:
		#Select the closest connector from the spawn point
		var closest_connector
		var distance = 999999
		for a in open_connectors[connection_type]:
			if sqrt(((spawn_location.x - a.x) ** 2) + ((spawn_location.y - a.y) ** 2)) < distance:
				closest_connector = a
		connector = closest_connector
		if !connector:
			connector = Vector2i(-1, -1)
	return connector

func generate_map():
	#Place the spawn at a random location
	spawn_location = Vector2i(randi_range(Config.map_size_x * 0.25, Config.map_size_x * 0.75), randi_range(Config.map_size_y * 0.25, Config.map_size_y * 0.75))
	var spawn = Globals.random_entry(Constants.spawn_room_arr).instantiate()
	spawn.init()
	place_room(spawn, spawn_location, Vector2i(0, 0))
	
	#Place filler rooms until the desired number is reached
	while filler_count < Config.min_room_count:
		var direction = select_connection()
		var connector = select_connector(direction)
		if connector == Vector2i(-1, -1):
			continue
		var ret = select_random_filler(direction, connector)
		if len(ret) > 0:
			var room = ret[0]
			var anchor = ret[1]
			#Delete the connector from the open connectors
			place_room(room, connector, anchor)
			filler_count += 1
	stuff_gaps()
	generate_special_objects()

#Fills open ends and empty connections
func stuff_gaps():
	for cell in $Map.get_used_cells():
		match $Map.get_cell_atlas_coords(cell):
			Constants.connectorL_ph:
				#Check if the tile left to the connector is empty or contains something
				if $Map.get_cell_atlas_coords(cell - Vector2i(1, 0)) != Vector2i(5, 1):
					var left_end = Globals.random_entry(Constants.left_end_arr).instantiate()
					left_end.init()
					place_room(left_end, cell, Vector2i(0, 4))
				else:
					var left_connector = Globals.random_entry(Constants.left_connector_arr).instantiate()
					left_connector.init()
					place_room(left_connector, cell, Vector2i(0, 4))
			
			Constants.connectorR_ph:
				if $Map.get_cell_atlas_coords(cell + Vector2i(1, 0)) != Vector2i(5,1):
					var right_end = Globals.random_entry(Constants.right_end_arr).instantiate()
					right_end.init()
					place_room(right_end, cell, Vector2i(0, 4))
				else:
					var left_connector = Globals.random_entry(Constants.left_connector_arr).instantiate()
					left_connector.init()
					place_room(left_connector, cell, Vector2i(0, 4))
			Constants.connectorU_ph:
				if $Map.get_cell_atlas_coords(cell - Vector2i(0, 1)) != Vector2i(5,1):
					var up_end = Globals.random_entry(Constants.up_end_arr).instantiate()
					up_end.init()
					place_room(up_end, cell, Vector2i(1, 0))
					$Map.set_cell(cell + Vector2i(2, 0), 0, Vector2i(4, 4))
					$Map.set_cell(cell + Vector2i(-2, 0), 0, Vector2i(3, 4))
					blocked.append(cell + Vector2i(-2, 0))
					blocked.append(cell + Vector2i(2, 0))
				else:
					var up_connector = Globals.random_entry(Constants.up_connector_arr).instantiate()
					up_connector.init()
					place_room(up_connector, cell, Vector2i(2, 0))
			Constants.connectorD_ph:
				if $Map.get_cell_atlas_coords(cell + Vector2i(0, 1)) != Vector2i(5,1):
					var down_end = Globals.random_entry(Constants.down_end_arr).instantiate()
					down_end.init()
					place_room(down_end, cell, Vector2i(2, 0))
				else:
					var up_connector = Globals.random_entry(Constants.up_connector_arr).instantiate()
					up_connector.init()
					place_room(up_connector, cell, Vector2i(2, 0))

#Places the room in the map at the given position relative to the rooms anchor point
func place_room(room, pos, anchor):
	#Places the tiles
	for x in range(pos.x - anchor.x, pos.x - anchor.x + room.size_x):
		for y in range(pos.y - anchor.y, pos.y - anchor.y + room.size_y):
			$Map.set_cell(Vector2i(x, y), 0, room.tiles[x - pos.x + anchor.x][y - pos.y + anchor.y])
			$Props.set_cell(Vector2i(x, y), room.props_atlas_index[x - pos.x + anchor.x][y - pos.y + anchor.y], room.props[x - pos.x + anchor.x][y - pos.y + anchor.y])
	#Adds the placed tiles to the array of blocked spaces
	for tile in room.blocked:
		blocked.append(tile - anchor + pos)
	#Adds the new connectors to the list of connectors
	for tile in room.connectors:
		open_connectors[room.connectors[tile]].append(tile - anchor + pos)

#Returns the tile on which the player should be spawned into the instance
func get_player_spawn_point():
	for x in range(spawn_location.x, spawn_location.x + 50):
		for y in range(spawn_location.y, spawn_location.y + 50):
			if $Map.get_cell_atlas_coords(Vector2i(x, y)) == Constants.player_spawn_point_ph:
				return $Map.map_to_local(Vector2i(x, y))

func generate_special_objects():
	for cell in $Map.get_used_cells():
		match $Map.get_cell_atlas_coords(cell):
			Vector2i(1, 18):
				var light = Constants.down_light.instantiate()
				light.color = Color.RED
				light.position = $Map.map_to_local(cell) + Vector2(0, 8)
				$Map.add_child(light)
			Vector2i(4, 18):
				var light = Constants.down_light.instantiate()
				light.color = Color.BLUE
				light.position = $Map.map_to_local(cell) + Vector2(0, 8)
				$Map.add_child(light)
			Vector2i(7, 18):
				var light = Constants.down_light.instantiate()
				light.color = Color.GREEN
				light.energy = 1
				light.position = $Map.map_to_local(cell) + Vector2(0, 8)
				$Map.add_child(light)
	for cell in $Props.get_used_cells():
		match $Props.get_cell_atlas_coords(cell):
			Vector2i(11, 5):#Wall torch
				$Props.erase_cell(cell)
				var torch = Constants.torch.instantiate()
				torch.position = $Props.map_to_local(cell)
				$Props.add_child(torch)
			Vector2i(12, 7):#Enemy
				$Props.erase_cell(cell)
				var skeleton = Constants.skeleton.instantiate()
				skeleton.position = $Props.map_to_local(cell)
				$Map.add_child(skeleton)
