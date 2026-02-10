extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.modulate.a += 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	$Sprite2D.modulate.a += 0.00001* delta
