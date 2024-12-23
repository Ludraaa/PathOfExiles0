extends Node2D

@onready var generated_map : PackedScene = preload("res://scenes/gen_map.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_map()

func generate_map():
	var map = generated_map.instantiate()
	map.name = "map"
	add_child(map)
	$Player.position = map.get_node("Map").map_to_local(map.spawn_location)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
