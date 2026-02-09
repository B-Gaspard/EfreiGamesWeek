extends PointLight2D
const MAX_RANGE = 200
const LIFETIME = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	texture.width = $Timer.time_left/LIFETIME * MAX_RANGE
	texture.height = $Timer.time_left/LIFETIME * MAX_RANGE
	
	if $Timer.is_stopped():
		queue_free()
