extends CharacterBody2D
const SPEED = 400
const ALIVE = 180


func _init() -> void:
	pass

func _process(delta: float) -> void:
	$AnimatedSprite2D.look_at(get_global_mouse_position())
	$AnimatedSprite2D.rotate(PI/2)
	
	$Battery.is_stopped()
	
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
