extends Node2D

@onready var player = $Player
var enemy_scene = preload("res://Assets/Scenes/enemy.tscn")
var led_scene = preload("res://Assets/Scenes/LED.tscn")
var tesla_scene = preload("res://Assets/Scenes/tesla.tscn")
var disjunktor_scene = preload("res://Assets/Scenes/disjunktor.tscn")
var score := 0
var kills = 0
var kills_quatrevingts =0
var disjunktor_spawned = false

func _ready() -> void:
	$AudioStreamPlayer.play()


func _on_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	enemy.global_position.x = randi_range(-380,380)
	enemy.global_position.y = randi_range(-260,220)
	while(enemy.global_position.distance_to(player.global_position)
	<$/root/World/Player/PointLight2D.texture.width/2):
		enemy.global_position.x = randi_range(-380,380)
		enemy.global_position.y = randi_range(-260,220)
	add_child(enemy)
	
	if randi_range(1,7)==5:
		var led = led_scene.instantiate()
		led.global_position.x = randi_range(-380,380)
		led.global_position.y = randi_range(-260,220)
		while(led.global_position.distance_to(player.global_position)
		<$/root/World/Player/PointLight2D.texture.width/2):
			led.global_position.x = randi_range(-380,380)
			led.global_position.y = randi_range(-260,220)
		add_child(led)

	if  randi_range(1,5)==4:
		var tesla = tesla_scene.instantiate()
		tesla.global_position.x = randi_range(-380,380)
		tesla.global_position.y = randi_range(-260,220)
		while(tesla.global_position.distance_to(player.global_position)
		<$/root/World/Player/PointLight2D.texture.width/2):
			tesla.global_position.x = randi_range(-380,380)
			tesla.global_position.y = randi_range(-260,220)
		add_child(tesla)

	if kills>=80 and !disjunktor_spawned:
		kills_quatrevingts +=1
		disjunktor_spawned=true
		var disjunktor = disjunktor_scene.instantiate()
		disjunktor.global_position=Vector2(0,-64)
		add_child(disjunktor)
