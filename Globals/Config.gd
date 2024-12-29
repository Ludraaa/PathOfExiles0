extends Node

#Radius around the player in which the fog should be cleared
const fog_clear_radius = 20

#map dimensions
const map_size_x = 100
const map_size_y = 100

#min number of filler rooms
const min_room_count = 40
#Minimap
var minimap_pos = Vector2(1570, 0)
var minimap_zoom_factor = Vector2(0.4, 0.4)
var minimap_big_zoom = Vector2i(0.2, 0.2)
