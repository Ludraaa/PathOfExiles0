extends Node2D

#Array containing all special rooms that should be in the map
@export var rooms = []

#Tilemap positions of left,right,up,down-facing connectors
@export var open_connectors = [[],[],[],[]]

#Array of all filler rooms to be useable
@export var room_lib = []

#Positions of all blocked spaces, where no room can cut in to
@export var blocked = []

#the maximum constraints of the map
@export var map_size_x = 100
@export var map_size_y = 100
@export var minimum_filler_count = 30

#Keeps track of the number of rooms currently
@export var filler_count = 0

#Position of the spawn tile
var spawn_location : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assemble_room_lib()
	generate_map()

#Gathers all the possible filler rooms into the array
func assemble_room_lib():
	room_lib.append(Constants.corridor_h)
	room_lib.append(Constants.corridor_v)
	room_lib.append(Constants.corner_lu)
	room_lib.append(Constants.corner_ru)
	room_lib.append(Constants.corner_ld)
	room_lib.append(Constants.corner_rd)
	room_lib.append(Constants.tjunktion_l)
	room_lib.append(Constants.tjunktion_r)
	room_lib.append(Constants.tjunktion_u)
	room_lib.append(Constants.tjunktion_d)
	room_lib.append(Constants.four_way)

#Selects a random room from the room_lib and checks for a possible connection, as well as blocked tiles
func select_random_filler(connection, anchor):
	var attempts = 5

	#Tries to find a matching room for the selected connector
	for attempt in range(attempts):
		var room = Globals.random_entry(room_lib).instantiate()
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
			if Vector2i(x, y) in blocked or x > map_size_x or y > map_size_y or x < 0 or y < 0:
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
		connector = Globals.random_entry(open_connectors[connection_type])
	else:
		#Select the closest connector from the spawn point
		var closest_connector
		var distance = 999999
		for a in open_connectors[connection_type]:
			if sqrt(((spawn_location.x - a.x) ** 2) + ((spawn_location.y - a.y) ** 2)) < distance:
				closest_connector = a
		connector = closest_connector
	return connector

func generate_map():
	#Place the spawn at a random location
	spawn_location = Vector2i(randi_range(map_size_x * 0.25, map_size_x * 0.75), randi_range(map_size_y * 0.25, map_size_y * 0.75))
	var spawn = Constants.spawn_room.instantiate()
	spawn.init()
	place_room(spawn, spawn_location, Vector2i(0, 0))
	
	#Place filler rooms until the desired number is reached
	while filler_count < minimum_filler_count:
		var direction = select_connection()
		var connector = select_connector(direction)
		var ret = select_random_filler(direction, connector)
		if len(ret) > 0:
			var room = ret[0]
			var anchor = ret[1]
			#Delete the connector from the open connectors
			place_room(room, connector, anchor)
			filler_count += 1
	stuff_gaps()

#Fills open ends and empty connections
func stuff_gaps():
	for cell in $Map.get_used_cells():
		match $Map.get_cell_atlas_coords(cell):
			Constants.connectorL_ph:
				#Check if the tile left to the connector is empty or contains something
				if $Map.get_cell_atlas_coords(cell - Vector2i(1, 0)) != Vector2i(5, 1):
					var left_end = Constants.left_end.instantiate()
					left_end.init()
					place_room(left_end, cell, Vector2i(0, 4))
				else:
					var left_connector = Constants.left_connector.instantiate()
					left_connector.init()
					place_room(left_connector, cell, Vector2i(0, 4))
			
			Constants.connectorR_ph:
				if $Map.get_cell_atlas_coords(cell + Vector2i(1, 0)) != Vector2i(5,1):
					var right_end = Constants.right_end.instantiate()
					right_end.init()
					place_room(right_end, cell, Vector2i(0, 4))
				else:
					var left_connector = Constants.left_connector.instantiate()
					left_connector.init()
					place_room(left_connector, cell, Vector2i(0, 4))
			Constants.connectorU_ph:
				if $Map.get_cell_atlas_coords(cell - Vector2i(0, 1)) != Vector2i(5,1):
					var up_end = Constants.up_end.instantiate()
					up_end.init()
					place_room(up_end, cell, Vector2i(1, 0))
					$Map.set_cell(cell + Vector2i(2, 0), 0, Vector2i(4, 4))
					$Map.set_cell(cell + Vector2i(-2, 0), 0, Vector2i(3, 4))
					blocked.append(cell + Vector2i(-2, 0))
					blocked.append(cell + Vector2i(2, 0))
				else:
					var up_connector = Constants.up_connector.instantiate()
					up_connector.init()
					place_room(up_connector, cell, Vector2i(2, 0))
			Constants.connectorD_ph:
				if $Map.get_cell_atlas_coords(cell + Vector2i(0, 1)) != Vector2i(5,1):
					var down_end = Constants.down_end.instantiate()
					down_end.init()
					place_room(down_end, cell, Vector2i(2, 0))
				else:
					var up_connector = Constants.up_connector.instantiate()
					up_connector.init()
					place_room(up_connector, cell, Vector2i(2, 0))

#Places the room in the map at the given position relative to the rooms anchor point
func place_room(room, pos, anchor):
	#Places the tiles
	for x in range(pos.x - anchor.x, pos.x - anchor.x + room.size_x):
		for y in range(pos.y - anchor.y, pos.y - anchor.y + room.size_y):
			$Map.set_cell(Vector2i(x, y), 0, room.tiles[x - pos.x + anchor.x][y - pos.y + anchor.y])
			$Props.set_cell(Vector2i(x, y), 1, room.props[x - pos.x + anchor.x][y - pos.y + anchor.y])
	#Adds the placed tiles to the array of blocked spaces
	for tile in room.blocked:
		blocked.append(tile - anchor + pos)
	#Adds the new connectors to the list of connectors
	for tile in room.connectors:
		open_connectors[room.connectors[tile]].append(tile - anchor + pos)
