extends PointLight2D
const MAX_RANGE = 400
const LIFETIME = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.texture.width = $Timer.time_left/LIFETIME * MAX_RANGE
	self.texture.height = $Timer.time_left/LIFETIME * MAX_RANGE
	
	if $Timer.is_stopped():
		queue_free()
