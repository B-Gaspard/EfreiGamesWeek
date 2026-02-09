extends CharacterBody2D
var lightning_scene = preload("res://Assets/Scenes/lightning.tscn")


func _on_fire_cooldown_timeout() -> void:
	var lightning = lightning_scene.instantiate()
	lightning.global_position = global_position
	$/root/World.add_child.call_deferred(lightning)
	print("instantiated lightning")
	
