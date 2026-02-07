extends Node2D

@onready var player = $Player
var enemy_scene = preload("res://Assets/Scenes/enemy.tscn")

func _on_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()

	var angle = randf() * TAU
	var distance = randf_range(200, 400)

	var offset = Vector2.RIGHT.rotated(angle) * distance
	enemy.global_position = player.global_position + offset

	add_child(enemy)
