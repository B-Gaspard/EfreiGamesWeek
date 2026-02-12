extends Area2D

func _on_body_entered(body):
	var player = body
	while player and not player.is_in_group("player"):
		player = player.get_parent()

	if player:
		player.add_fire_rate_upgrade()
		queue_free()
