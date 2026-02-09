extends Node2D

func _process(delta: float) -> void:
	if $/root/World/Player.actionnable:
		look_at(get_global_mouse_position())
