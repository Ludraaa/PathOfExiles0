extends Node2D

#Array for all special rooms to be in the map
@export var rooms = []

#Positions of open connectors in the various directions
@export var open_connectors = [[],[],[],[]]

#Array of all filler rooms to be useable
@export var room_lib = []

#Positions of all blocked spaces, where no room can cut in to
@export var blocked = []

#the maximum constraints of the map
@export var map_size_x = 100
@export var map_size_y = 100
@export var minimum_filler_count = 100

#Keeps track of the number of rooms currently
@export var filler_count = 0

#Position of the spawn tile
var spawn_location : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assemble_room_lib()
	generate_map()

#Gathers all the possible rooms into the array
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

#Selects a random room from the room_lib and checks for a possible connection, as well as blocked tiles
func select_random_filler(connection, anchor):
	var attempts = 10

	#Tries to find a matching room for the selected connector
	for attempt in range(attempts):
		var random_index = randi_range(0, len(room_lib) - 1)
		var room = room_lib[random_index].instantiate()
		room.init()
		if len(room.anchors[Constants.invConnectionTypeList[connection]]) > 0:
			#Select a random connection in the correct direction and check for collision with other rooms
			var random_connector = room.anchors[Constants.invConnectionTypeList[connection]][randi_range(0, len(room.anchors[Constants.invConnectionTypeList[connection]]) - 1)]
			if check_blocked(room, random_connector, anchor):
				return [room, random_connector]
	return []
	
#Checks if the given room would collide with any existing rooms
func check_blocked(room, anchor, pos):
	for x in range(pos.x - anchor.x, pos.x - anchor.x + room.size_x):
		for y in range(pos.y - anchor.y, pos.y - anchor.y + room.size_y):
			if Vector2i(x, y) in blocked:
				return false
	return true

#Selects a random connection type
func select_connection():
	#Choose a random connection type 
	var connection_r = randi_range(0, 3)
	var connection_type = Constants.ConnectionTypeList[connection_r]
	return connection_type

#Selects the furthest connection from spawn, with a chance to take a random one
func select_connector(connection_type):
	#Choose a random connector with exploration
	var pos_r = randi_range(1, 10)
	var connector
	if pos_r > 6:
		#Selects a random connector of the given direction
		var connector_r =  randi_range(0, len(open_connectors[connection_type]) - 1)
		connector = open_connectors[connection_type][connector_r]
	else:
		#Select the farthest connector from the spawn point
		var farthest_connector
		var max_distance = 0
		for a in open_connectors[connection_type]:
			if sqrt(((spawn_location.x - a.x) ** 2) + ((spawn_location.y - a.y) ** 2)) > max_distance:
				farthest_connector = a
		connector = farthest_connector
	return connector

func generate_map():
	#Place the spawn at a random location
	spawn_location = Vector2i(randi_range(0, map_size_x), randi_range(0, map_size_y))
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
				"""
				if $Map.get_cell_atlas_coords(cell + Vector2i(1, 0)) != Vector2i(5, 1):
					$Map.set_cell(cell, 0, Vector2i(4, 5))
					$Map.set_cell(cell + Vector2i(0, 1), 0, Vector2i(4, 5))
					$Map.set_cell(cell - Vector2i(0, 1), 0, Vector2i(4, 5))
					$Map.set_cell(cell- Vector2i(0, 2), 0, Vector2i(4, 5))
					$Map.set_cell(cell - Vector2i(0, 3), 0, Vector2i(4, 5))
					$Map.set_cell(cell - Vector2i(0, 4), 0, Vector2i(4, 4))
					$Map.set_cell(cell + Vector2i(0, 2), 0, Vector2i(4, 6))
				else:
					$Map.set_cell(cell + Vector2i(0, 1), 0, Vector2i(5, 2))
					$Map.set_cell(cell - Vector2i(0, 1), 0, Vector2i(5, 0))
					$Map.set_cell(cell, 0, Vector2i(5, 1))
					$Map.set_cell(cell - Vector2i(0, 2), 0, Vector2i(3, 0))
					$Map.set_cell(cell + Vector2i(0, 2), 0, Vector2i(1, 3))
					"""
			Constants.connectorU_ph:
				"""
				if $Map.get_cell_atlas_coords(cell - Vector2i(0, 1)) != Vector2i(5, 1):
					$Map.set_cell(cell - Vector2i(0, -2), 0, Vector2i(1, 2))
					$Map.set_cell(cell - Vector2i(0, -1), 0, Vector2i(1, 1))
					$Map.set_cell(cell - Vector2i(0, 0), 0, Vector2i(1, 0))
					
					$Map.set_cell(cell + Vector2i(1, 2), 0, Vector2i(2, 2))
					$Map.set_cell(cell - Vector2i(-1, -1), 0, Vector2i(2, 1))
					$Map.set_cell(cell - Vector2i(-1, 0), 0, Vector2i(2, 0))
					
					$Map.set_cell(cell - Vector2i(1, -2), 0, Vector2i(0, 2))
					$Map.set_cell(cell - Vector2i(1, -1), 0, Vector2i(0, 1))
					$Map.set_cell(cell - Vector2i(1, 0), 0, Vector2i(0, 0))
					
					$Map.set_cell(cell + Vector2i(2, 0), 0, Vector2i(4, 4))
					
					$Map.set_cell(cell - Vector2i(2, 0), 0, Vector2i(3, 4))
					"""
func place_room(room, pos, anchor):
	for x in range(pos.x - anchor.x, pos.x - anchor.x + room.size_x):
		for y in range(pos.y - anchor.y, pos.y - anchor.y + room.size_y):
			$Map.set_cell(Vector2i(x, y), 0, room.tiles[x - pos.x + anchor.x][y - pos.y + anchor.y])
	for tile in room.blocked:
		blocked.append(tile - anchor + pos)
	for tile in room.connectors:
		open_connectors[room.connectors[tile]].append(tile - anchor + pos)
