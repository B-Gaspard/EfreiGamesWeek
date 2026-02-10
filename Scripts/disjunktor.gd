extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
@onready var fodder_scene = preload("res://Assets/Scenes/enemy.tscn")
var fodder_num = 3
var HP = 1000

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation=="apparition":
		anim.play("idle")
		$SpawnCooldown.wait_time=7
	elif anim.animation=="spawner_innit":
		anim.play("spawner")
		$HitboxArea/Hitbox.disabled=false
		$FodderTimer.start()

func _on_spawn_cooldown_timeout() -> void:
	anim.play("spawner_innit")

func _on_fodder_timer_timeout() -> void:
	if fodder_num == 0:
		anim.play("idle")
		$SpawnCooldown.start()
		fodder_num=3
		$HitboxArea/Hitbox.disabled=true

	else:
		var fodder = fodder_scene.instantiate()
		fodder.global_position = global_position
		fodder.global_position.y+=60
		$/root/World.add_child.call_deferred(fodder)
		$FodderTimer.start()
		fodder_num-=1
