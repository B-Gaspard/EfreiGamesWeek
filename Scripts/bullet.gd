extends Node2D

var explosion_scene = preload("res://Assets/Scenes/bullet_explosion.tscn")
var boots = preload("res://Assets/Scenes/bootsUpgrade.tscn")
var guns = preload("res://Assets/Scenes/bulletsUpgrade.tscn")
signal ennemy_died


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
	if body.is_in_group("enemies"):
		body.queue_free()
		queue_free()
		

		emit_signal("ennemy_died",800)

		# --- Random boots drop ---
		if randf() < 0.05:
			var drop = boots.instantiate()
			drop.global_position = body.global_position
			$/root/World.add_child(drop)
		elif randf() < 0.01:
			var drop = guns.instantiate()
			drop.global_position = body.global_position
			$/root/World.add_child(drop)

		# --- Explosion ---
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		explosion.emitting = true
		explosion.lifetime = randf_range(0.3, 0.7)
		$/root/World.add_child(explosion)

		body.queue_free()
		queue_free()
		
		
	elif body.is_in_group("Obstacle"):
		
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		explosion.emitting = true
		explosion.lifetime = randf_range(0.3, 0.7)
		$/root/World.add_child(explosion)
		queue_free()


func _on_ennemy_died(points) -> void:
	player.score+=points
	$/root/World/Player.life += 50
