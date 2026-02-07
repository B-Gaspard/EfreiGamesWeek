extends Node2D

@onready var player = $Player
var enemy_scene = preload("res://Assets/Scenes/enemy.tscn")
var score := 0

func _on_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	enemy.global_position = player.global_position
	while enemy.global_position.distance_squared_to(player.global_position) < 10000:
		enemy.global_position.x = randi_range(0, get_viewport_rect().size.x)
		enemy.global_position.y = randi_range(0, get_viewport_rect().size.y)
	add_child(enemy)

func _on_enemy_died():
	print("Score:", score)
