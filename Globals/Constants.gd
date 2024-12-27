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
var spawn_room1 = preload("res://rooms/rooms/spawn_room/spawn_room1.tscn")
var spawn_room2 = preload("res://rooms/rooms/spawn_room/spawn_room2.tscn")
var spawn_room3 = preload("res://rooms/rooms/spawn_room/spawn_room3.tscn")
var spawn_room_arr = [spawn_room1, spawn_room2, spawn_room3]

var corridor_h1 = preload("res://rooms/rooms/corridor_h/corridor_h1.tscn")
var corridor_h_arr = [corridor_h1]

var corridor_v1 = preload("res://rooms/rooms/corridor_v/corridor_v1.tscn")
var corridor_v_arr = [corridor_v1]

var corner_lu1 = preload("res://rooms/rooms/corner_lu/corner_lu1.tscn")
var corner_lu_arr = [corner_lu1]

var corner_ru1 = preload("res://rooms/rooms/corner_ru/corner_ru1.tscn")
var corner_ru_arr = [corner_ru1]

var corner_ld1 = preload("res://rooms/rooms/corner_ld/corner_ld1.tscn")
var corner_ld_arr = [corner_ld1]

var corner_rd1 = preload("res://rooms/rooms/corner_rd/corner_rd1.tscn")
var corner_rd_arr = [corner_rd1]

var tjunktion_l1 = preload("res://rooms/rooms/tjunktion_l/tjunktion_l1.tscn")
var tjunktion_l_arr = [tjunktion_l1]

var tjunktion_r1 = preload("res://rooms/rooms/tjunktion_r/tjunktion_r1.tscn")
var tjunktion_r_arr = [tjunktion_r1]

var tjunktion_u1 = preload("res://rooms/rooms/tjunktion_u/tjunktion_u1.tscn")
var tjunktion_u_arr = [tjunktion_u1]

var tjunktion_d1 = preload("res://rooms/rooms/tjunktion_d/tjunktion_d1.tscn")
var tjunktion_d_arr = [tjunktion_d1]

var four_way1 = preload("res://rooms/rooms/four_way/four_way1.tscn")
var four_way_arr = [four_way1]

#Preload all possible complexes
var complex_a1 = preload("res://rooms/complexes/complex_a/complex_a1.tscn")
var complex_a2 = preload("res://rooms/complexes/complex_a/complex_a2.tscn")
var complex_a_arr = [complex_a1, complex_a2]

var complex_b1 = preload("res://rooms/complexes/complex_b/complex_b1.tscn")
var complex_b_arr = [complex_b1]

#Preload paddings
var left_end1 = preload("res://rooms/padding/left_end/left_end1.tscn")
var left_end_arr = [left_end1]

var left_connector1 = preload("res://rooms/padding/left_connector/left_connector1.tscn")
var left_connector2 = preload("res://rooms/padding/left_connector/left_connector2.tscn")
var left_connector_arr = [left_connector1, left_connector2]

var right_end1 = preload("res://rooms/padding/right_end/right_end1.tscn")
var right_end_arr = [right_end1]

var up_end1 = preload("res://rooms/padding/up_end/up_end1.tscn")
var up_end_arr = [up_end1]

var up_connector1 = preload("res://rooms/padding/up_connector/up_connector1.tscn")
var up_connector2 = preload("res://rooms/padding/up_connector/up_connector2.tscn")
var up_connector_arr = [up_connector1, up_connector2]

var down_end1 = preload("res://rooms/padding/down_end/down_end1.tscn")
var down_end_arr = [down_end1]
