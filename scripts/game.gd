extends Node2D

@onready var generated_map : PackedScene = preload("res://scenes/gen_map.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_map()

func generate_map():
	var map = generated_map.instantiate()
	Globals.curr_map = map
	add_child(map)
	$CanvasLayer/Minimap/SubViewportContainer/SubViewport/minimap_map.sketch_map()
	$CanvasLayer/Minimap/SubViewportContainer/SubViewport/minimap_map.generate_fog()
	$Player.position = map.get_player_spawn_point()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
