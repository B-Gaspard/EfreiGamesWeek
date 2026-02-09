extends CharacterBody2D

@onready var player = $/root/World/Player

const SPEED = 100

func _physics_process(delta: float) -> void:
	velocity = (player.global_position - global_position).normalized() * SPEED
	move_and_slide()
