extends Node2D

@onready var player = $Player
var enemy_scene = preload("res://Assets/Scenes/enemy.tscn")
var led_scene = preload("res://Assets/Scenes/LED.tscn")
var score := 0

func _ready() -> void:
	$AudioStreamPlayer.play()
	

func _on_timer_timeout() -> void:
	
	
	var enemy = enemy_scene.instantiate()

	var angle = randf() * TAU
	var distance = randf_range(200, 400)

	var offset = Vector2.RIGHT.rotated(angle) * distance
	enemy.global_position = player.global_position + offset
	
	if randi_range(1,10)==5:
		var led = led_scene.instantiate()
		led.global_position = player.global_position + offset
		add_child(led)

	add_child(enemy)
