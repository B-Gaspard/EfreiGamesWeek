extends Node2D
const SPEED = 100
@onready var player = $/root/World/Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	look_at(player.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_local_x(SPEED*delta)

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Obstacle")):
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
