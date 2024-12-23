extends Node

#TileAtlasCoords mapped to room elements
const walkable_ph = Vector2i(6, 0)
const wall_ph = Vector2i(0, 1)
const connectorL_ph = Vector2i(1, 0)
const connectorR_ph = Vector2i(2, 0)
const connectorU_ph = Vector2i(3, 0)
const connectorD_ph = Vector2i(4, 0)

enum ConnectionType {LEFT, RIGHT, UP, DOWN}
const ConnectionTypeList = [ConnectionType.LEFT, ConnectionType.RIGHT, ConnectionType.UP, ConnectionType.DOWN]
enum invConnectionType {RIGHT, LEFT, DOWN, UP}
const invConnectionTypeList = [ConnectionType.RIGHT, ConnectionType.LEFT, ConnectionType.DOWN, ConnectionType.UP]

#Preload all the different possible rooms
var spawn_room = preload("res://rooms/scenes/spawn_room.tscn")
var corridor_h = preload("res://rooms/scenes/corridor_h.tscn")
var corridor_v = preload("res://rooms/scenes/corridor_v.tscn")
var corner_lu = preload("res://rooms/scenes/corner_lu.tscn")
var corner_ru = preload("res://rooms/scenes/corner_ru.tscn")
var corner_ld = preload("res://rooms/scenes/corner_ld.tscn")
var corner_rd = preload("res://rooms/scenes/corner_rd.tscn")
var tjunktion_l = preload("res://rooms/scenes/tjunktion_l.tscn")
var tjunktion_r = preload("res://rooms/scenes/tjunktion_r.tscn")
var tjunktion_u = preload("res://rooms/scenes/tjunktion_u.tscn")
var tjunktion_d = preload("res://rooms/scenes/tjunktion_d.tscn")
