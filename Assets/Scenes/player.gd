extends CharacterBody2D
const SPEED = 1200


func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()

func _physics_process(delta: float) -> void:
	var move_dir = Vector2(Input.get_axis("Left","Right"),
	Input.get_axis("Up","Down"))
	
	if move_dir != Vector2.ZERO:
		velocity = move_dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()
