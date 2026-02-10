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
	var distance = $Player/PointLight2D.texture.width/2

	var offset = Vector2.RIGHT.rotated(angle)*distance
	enemy.global_position = player.global_position + offset
	var cnt = 15
	while(enemy.global_position.x>370 or enemy.global_position.x<-370 or enemy.global_position.y<-240 or enemy.global_position.y>240 or cnt>0):
		print(enemy.global_position)
		angle = randf() * TAU
		offset = Vector2.RIGHT.rotated(angle) * distance* (randf()+1)
		enemy.global_position = player.global_position + offset
		cnt-=1
	if (cnt==0):
		print("\n\n\n Attenzione !!!! \n\n\n")
	
	
	if randi_range(1,10)==5:
		var led = led_scene.instantiate()
		led.global_position = player.global_position + offset
		add_child(led)

	add_child(enemy)
