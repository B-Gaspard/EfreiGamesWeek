extends CharacterBody2D
@onready var anim = $AnimatedSprite2D

func _process(delta):
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation=="apparition":
		anim.play("idle")
	elif anim.animation=="spawner_innit":
		anim.play("spawner")

func _on_spawn_cooldown_timeout() -> void:
	anim.play("spawner_innit")
