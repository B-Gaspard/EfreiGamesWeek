extends AnimatedSprite2D


func _on_time_change_timeout() -> void:
	play("shake")


func _on_time_out_timeout() -> void:
	visible = false
