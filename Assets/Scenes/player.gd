extends CharacterBody2D
const SPEED = 400
const TTL_MAX = 500
var actionnable = true

var bullet_scene = preload("res://Assets/Scenes/bullet.tscn")
@onready var shooty_part = $Hand/ShootyPart 
var label_text = "Score : %s"
var score = 0

# Start with 1 barrel straight ahead
var gun_angles: Array[float] = [0.0]
var gun_spread_deg: float = 35.0  # Total spread between outermost barrels
var barrel_muzzle_distance: float = 16.0  # pixels from center

func _process(delta: float) -> void:
	$AnimatedSprite2D.look_at(get_global_mouse_position())
	$AnimatedSprite2D.rotate(PI/2)
	
	score+=1
	light_radius-=8*get_process_delta_time()
	
	if light_radius <=0:
		lose()
	
	var actual_text = label_text % [score,light_radius]
	
	$PointLight2D.texture.height = light_radius
	$PointLight2D.texture.width=$PointLight2D.texture.height
# ---- FUNCTIONS ----

# Add another barrel, automatically distributed
func add_gun_upgrade():
	print("Gun upgrade received")
	var num_barrels = gun_angles.size() + 1
	gun_angles.clear()
	# Calculate symmetrical angles around 0
	if num_barrels == 1:
		gun_angles = [0.0]
	else:
		for i in range(num_barrels):
			var angle = lerp(-gun_spread_deg/2, gun_spread_deg/2, float(i)/(num_barrels-1))
			gun_angles.append(angle)
	print("Current gun angles:", gun_angles)

func add_speed(amount):
	SPEED += amount

# ---- PROCESS LOOP ----

func _process(delta: float) -> void:
	score += 1
	var actual_text = label_text % score
	$Battery.is_stopped()
	
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
		
	$BoxContainer/Label.text = actual_text

func _physics_process(delta: float) -> void:
	# Move player
	var move_dir = Vector2(Input.get_axis("Left","Right"), Input.get_axis("Up","Down"))
	if move_dir != Vector2.ZERO:
		velocity = move_dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if actionnable:
		move_and_slide()

func lose():
	actionnable = false


func _on_body_entered(body: Area2D) :
	if(body.is_in_group("enemies")):
		lose()

	# Shooting
	if Input.is_action_just_pressed("shoot"):
		var base_dir = (get_global_mouse_position() - shooty_part.global_position).normalized()
		var base_angle = base_dir.angle()

		for angle_offset_deg in gun_angles:
			var bullet = bullet_scene.instantiate()
			
			# Direction vector
			var dir = Vector2.from_angle(base_angle + deg_to_rad(angle_offset_deg))

			# Muzzle offset so bullets don't overlap
			var muzzle_offset = Vector2(barrel_muzzle_distance, 0).rotated(base_angle + deg_to_rad(angle_offset_deg))
			bullet.global_position = shooty_part.global_position + muzzle_offset

			bullet.direction = dir
			$/root/World.add_child(bullet)

	move_and_slide()
