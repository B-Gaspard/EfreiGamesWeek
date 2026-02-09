extends Node2D

var explosion_scene = preload("res://Assets/Scenes/bullet_explosion.tscn")
var boots = preload("res://Assets/Scenes/bootsUpgrade.tscn")
var guns = preload("res://Assets/Scenes/bulletsUpgrade.tscn")
signal battery_killed
signal led_killed


@export var speed := 800.0
@onready var player = $/root/World/Player


var direction: Vector2 = Vector2.RIGHT


const SPEED = 600
func _ready():
	rotation = direction.angle()
	


func _physics_process(delta):
		position += direction * speed * delta
func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("LED"):
		body.queue_free()
		queue_free()
		emit_signal("led_killed",800)
		random_drop()
		explosion_fx()
	
	if body.is_in_group("Battery"):
		body.queue_free()
		queue_free()
		emit_signal("battery_killed",800)

		random_drop()
		explosion_fx()
		
	elif body.is_in_group("Obstacle"):
		explosion_fx()
		queue_free()


func _on_battery_killed(points) -> void:
	player.score+=points
	$/root/World/Player.life += 50

func _on_led_killed(points) -> void:
	$/root/World/Player.life += 50

func random_drop():
	if randf() < 0.05:
		var drop = boots.instantiate()
		drop.global_position = global_position
		$/root/World.add_child(drop)
	elif randf() < 0.01:
		var drop = guns.instantiate()
		drop.global_position = global_position
		$/root/World.add_child(drop)

func explosion_fx():
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		explosion.emitting = true
		explosion.lifetime = randf_range(0.3, 0.7)
		$/root/World.add_child(explosion)
