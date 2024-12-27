class_name Room
extends TileMapLayer

#Room dimensions
@export var size_x : int
@export var size_y : int

#Possible connections to other tiles
@export var anchors = [[],[],[],[]]

#List of all connectors, regardless of direction
@export var connectors = {}
#List of all spaces blocked by this room
@export var blocked = []

#Contains the atlas coords to be able to place this room
@export var tiles = []
@export var props = []

#Initializes the room
#Godot's standard _ready function is not used since these scenes do not ever enter the tree
#As such, this method has to be called manually before trying to place this room
func init():
	get_size()
	assign_tiles()
	get_tiles()

#Iterates over the entire room and assigns the tiles into the variables as needed
func assign_tiles():
	for x in range(size_x):
		for y in range(size_y):
			var tile = get_cell_atlas_coords(Vector2i(x, y))
			if tile == Constants.connectorL_ph:
				connectors[Vector2i(x, y)] = Constants.ConnectionType.LEFT
				anchors[0].append(Vector2i(x, y))
			elif tile == Constants.connectorU_ph:
				connectors[Vector2i(x, y)] = Constants.ConnectionType.UP
				anchors[2].append(Vector2i(x, y))
			elif tile == Constants.connectorR_ph:
				connectors[Vector2i(x, y)] = Constants.ConnectionType.RIGHT
				anchors[1].append(Vector2i(x, y))
			elif tile == Constants.connectorD_ph:
				connectors[Vector2i(x, y)] = Constants.ConnectionType.DOWN
				anchors[3].append(Vector2i(x, y))
			if tile != Vector2i(-1, -1) and tile != Constants.connectorL_ph and tile != Constants.connectorR_ph and tile != Constants.connectorU_ph and tile != Constants.connectorD_ph:
				blocked.append(Vector2i(x, y))

#Gets the atlas coords of every tile, so it can be placed down later
func get_tiles():
	for x in range(size_x):
		var columnTiles = []
		var columnProps = []
		for y in range(size_y):
			columnTiles.append(get_cell_atlas_coords(Vector2i(x, y)))
			columnProps.append($Props.get_cell_atlas_coords(Vector2i(x, y)))
		tiles.append(columnTiles)
		props.append(columnProps)

#Gets dimensions of the room itself
func get_size():
	var max_x = 0
	var max_y = 0
	for cell in get_used_cells():
		if cell.x > max_x:
			max_x = cell.x
		if cell.y > max_y:
			max_y = cell.y
	size_x = max_x + 1
	size_y = max_y + 1
