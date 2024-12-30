extends Panel
var color = Color.RED
var max_val
var curr_val

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.color = color
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ColorRect.size.x = (curr_val / max_val) * 20
	if curr_val <= 0:
		hide()
