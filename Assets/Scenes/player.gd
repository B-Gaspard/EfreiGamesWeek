extends CharacterBody2D
const SPEED = 400
const ALIVE = 180

var bullet_scene = preload("res://Assets/Scenes/bullet.tscn")
@onready var shooty_part = $ShootyPart 
var label_text = "Score : %s"
var score = 0

func _init() -> void:
	pass

func _process(delta: float) -> void:
	$AnimatedSprite2D.look_at(get_global_mouse_position())
	$AnimatedSprite2D.rotate(PI/2)
	
	score+=1*get_process_delta_time()
	
	var actual_text = label_text % score
	$Battery.is_stopped()
	
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
		
	$BoxContainer/Label.text = actual_text
	

func _physics_process(delta: float) -> void:
	var move_dir = Vector2(Input.get_axis("Left","Right"),
	Input.get_axis("Up","Down"))
	
	if move_dir != Vector2.ZERO:
		velocity = move_dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	if Input.is_action_just_pressed("shoot"):
		var bullet = bullet_scene.instantiate()
		bullet.global_position = shooty_part.global_position
		bullet.direction =(get_global_mouse_position() - global_position).normalized()
		$/root/World.add_child(bullet)
	
	move_and_slide()
