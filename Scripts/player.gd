extends CharacterBody2D
const SPEED = 100
var bullet_scene = preload("res://Assets/Scenes/bullet.tscn")
@onready var shooty_part = $ShootyPart  


func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	velocity.x = Input.get_axis("Left", "Right") * SPEED
	velocity.y = Input.get_axis("Up", "Down") * SPEED


	if Input.is_action_just_pressed("shoot"):
		var bullet = bullet_scene.instantiate()
		bullet.global_position = shooty_part.global_position
		bullet.direction =(get_global_mouse_position() - global_position).normalized()
		$/root/Game.add_child(bullet)
	move_and_slide()
