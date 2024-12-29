extends Node2D

@onready var generated_map : PackedScene = preload("res://scenes/gen_map.tscn")
@onready var player = preload("res://scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().paused = false
	$PauseMenu.hide()
	generate_map()

func generate_map():
	var map = generated_map.instantiate()
	Globals.curr_map = map
	var player_instance = player.instantiate()
	map.add_child(player_instance)
	add_child(map)
	player_instance.position = map.get_player_spawn_point()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		var tree = get_tree()
		if !tree.paused:
			tree.paused = true
			$PauseMenu.show()


func _on_resume_button_pressed() -> void:
	$PauseMenu.hide()
	get_tree().paused = false
