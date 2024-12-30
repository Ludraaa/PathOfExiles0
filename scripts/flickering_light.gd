extends PointLight2D

@export var noise : NoiseTexture2D
var time_passed = randf_range(0, 1000)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	
	var sampled_noise = noise.noise.get_noise_1d(time_passed * 3)
	sampled_noise = abs(sampled_noise) * 8
	energy = max(sampled_noise, 1.0)
