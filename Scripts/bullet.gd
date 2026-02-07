extends Area2D

var direction: Vector2
var explosion_scene = preload("res://Assets/Scenes/bullet_explosion.tscn")
const SPEED = 25

signal ennemy_died

func _physics_process(delta: float) -> void:
	global_position += direction * SPEED


func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		emit_signal("ennemy_died")
		body.queue_free()
		queue_free()
		
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		explosion.emitting = true
		explosion.lifetime = randf_range(0.3, 0.7)
		$/root/World.add_child(explosion)
		
		
	elif body.is_in_group("Obstacle"):
		
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		explosion.emitting = true
		explosion.lifetime = randf_range(0.3, 0.7)
		$/root/World.add_child(explosion)
		queue_free()
