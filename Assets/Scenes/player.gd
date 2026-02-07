extends CharacterBody2D

var SPEED = 80
const ALIVE = 180

var bullet_scene = preload("res://Assets/Scenes/bullet.tscn")
@onready var shooty_part = $Hand/ShootyPart 
var label_text = "Score : %s\nTTL: %s"
var score = 0
var actionnable = true

# Start with 1 barrel straight ahead
var gun_angles: Array[float] = [0.0]
var gun_spread_deg: float = 35.0  # Total spread between outermost barrels
var barrel_muzzle_distance: float = 16.0  # pixels from center


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
	$CockFX.play()

func add_speed(amount):
	SPEED += amount
	$BootFX.play()

# ---- PROCESS LOOP ----
var life = 500.00
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reSTART") :
		get_tree().reload_current_scene()
	
	if actionnable:
		score += 1
	else :
		life-=670*get_process_delta_time()
		
	var actual_text = label_text % [score,$PointLight2D.texture.width]
	
	life = min(life, 750)
	life-=75*get_process_delta_time()
	var targetzoom = (1500/life - $Camera2D.zoom.x)/20
	
	$Camera2D.zoom.x += targetzoom
	$Camera2D.zoom.y += targetzoom
	
	$PointLight2D.texture.width = life
	$PointLight2D.texture.height= life
	
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
		
	$Camera2D/BoxContainer/Label.text = actual_text

func _physics_process(delta: float) -> void:
	# Move player
	var move_dir = Vector2(Input.get_axis("Left","Right"), Input.get_axis("Up","Down"))
	if move_dir != Vector2.ZERO:
		velocity = move_dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Shooting
	if Input.is_action_just_pressed("shoot") and actionnable:
		$GunAudio.play()
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

	if actionnable:
		move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and actionnable:
		lose()
	
func lose():
	actionnable = false
	$DeathFX.play()
