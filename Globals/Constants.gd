extends Node

#TileAtlasCoords mapped to room elements
const connectorL_ph = Vector2i(3, 10)
const connectorR_ph = Vector2i(4, 10)
const connectorU_ph = Vector2i(4, 9)
const connectorD_ph = Vector2i(4, 8)
const player_spawn_point_ph = Vector2i(8, 1)

enum ConnectionType {LEFT, RIGHT, UP, DOWN}
const ConnectionTypeList = [ConnectionType.LEFT, ConnectionType.RIGHT, ConnectionType.UP, ConnectionType.DOWN]
enum invConnectionType {RIGHT, LEFT, DOWN, UP}
const invConnectionTypeList = [ConnectionType.RIGHT, ConnectionType.LEFT, ConnectionType.DOWN, ConnectionType.UP]
#Colors
const bg_color = Color("141412")

#Special objects
var down_light = preload("res://scenes/down_light.tscn")



#Preload all the different possible rooms
var spawn_room_arr = [
	preload("res://rooms/rooms/spawn_room/spawn_room1.tscn"),
	preload("res://rooms/rooms/spawn_room/spawn_room2.tscn"),
	preload("res://rooms/rooms/spawn_room/spawn_room3.tscn")
]
var corridor_h_arr = [
	preload("res://rooms/rooms/corridor_h/corridor_h1.tscn"),
	preload("res://rooms/rooms/corridor_h/corridor_h2.tscn")
]
var corridor_v_arr = [
	preload("res://rooms/rooms/corridor_v/corridor_v1.tscn")
	]
var corner_lu_arr = [
	preload("res://rooms/rooms/corner_lu/corner_lu1.tscn"),
	preload("res://rooms/rooms/corner_lu/corner_lu2.tscn")
]
var corner_ru_arr = [
	preload("res://rooms/rooms/corner_ru/corner_ru1.tscn")
	]
var corner_ld_arr = [
	preload("res://rooms/rooms/corner_ld/corner_ld1.tscn"),
	preload("res://rooms/rooms/corner_ld/corner_ld2.tscn")
]
var corner_rd_arr = [
	preload("res://rooms/rooms/corner_rd/corner_rd1.tscn")
	]
var tjunktion_l_arr = [
	preload("res://rooms/rooms/tjunktion_l/tjunktion_l1.tscn")
	]
var tjunktion_r_arr = [
	preload("res://rooms/rooms/tjunktion_r/tjunktion_r1.tscn")
]
var tjunktion_u_arr = [
	preload("res://rooms/rooms/tjunktion_u/tjunktion_u1.tscn")
]
var tjunktion_d_arr = [
	preload("res://rooms/rooms/tjunktion_d/tjunktion_d1.tscn")
]
var four_way_arr = [
	preload("res://rooms/rooms/four_way/four_way1.tscn")
]

#Preload all possible complexes
var complex_a_arr = [
	preload("res://rooms/complexes/complex_a/complex_a1.tscn"),
	preload("res://rooms/complexes/complex_a/complex_a2.tscn"),
	preload("res://rooms/complexes/complex_a/complex_a3.tscn")
]
var complex_b_arr = [
	preload("res://rooms/complexes/complex_b/complex_b1.tscn"),
	preload("res://rooms/complexes/complex_b/complex_b2.tscn")
]
var complex_c_arr = [
	preload("res://rooms/complexes/complex_c/complex_c1.tscn")
]

#Preload paddings
var left_end_arr = [
	preload("res://rooms/padding/left_end/left_end1.tscn")
	]
var left_connector_arr = [
	preload("res://rooms/padding/left_connector/left_connector1.tscn"),
	preload("res://rooms/padding/left_connector/left_connector2.tscn"),
	preload("res://rooms/padding/left_connector/left_connector3.tscn")
]
var right_end_arr = [
	preload("res://rooms/padding/right_end/right_end1.tscn")
	]
var up_end_arr = [
	preload("res://rooms/padding/up_end/up_end1.tscn")
]
var up_connector_arr = [
	preload("res://rooms/padding/up_connector/up_connector1.tscn"),
	preload("res://rooms/padding/up_connector/up_connector2.tscn"),
	preload("res://rooms/padding/up_connector/up_connector3.tscn")
]
var down_end_arr = [
	preload("res://rooms/padding/down_end/down_end1.tscn")
]

#Preload other special objects
var torch = preload("res://scenes/torch.tscn")

#Preload enemies
var skeleton = preload("res://scenes/skeleton.tscn")
