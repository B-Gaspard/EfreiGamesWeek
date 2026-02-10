extends CharacterBody2D

var SPEED = 100
const ALIVE = 180
const COOLDOWN = 1

var zoom = false

var bullet_scene = preload("res://Assets/Scenes/bullet.tscn")
@onready var shooty_part = $Hand/ShootyPart 
@onready var anim = $AnimatedSprite2D
var label_text = "Score : %s\nTTL: %s"
var score = 0
var actionnable = true
var can_shoot = true
var targetzoom

# Start with 1 barrel straight ahead
var gun_angles: Array[float] = [0.0]
var gun_spread_deg: float = 35.0  # Total spread between outermost barrels
var barrel_muzzle_distance: float = 16.0  # pixels from center

var time_elapsed = 0
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

func add_fire_rate_upgrade():
	print("fire rate upgrade received")

	$FireCooldown.wait_time = max(
		$FireCooldown.wait_time - 0.1,
		0.1
	)
	if $FireCooldown.wait_time == 0.1:
		add_gun_upgrade()
	
func add_speed(amount):
	SPEED += amount
	$BootFX.play()

# ---- PROCESS LOOP ----
var life = 1000.00
func _process(delta: float) -> void:
	time_elapsed+=delta
	
	if Input.is_action_just_pressed("reSTART") :
		get_tree().reload_current_scene()
	
	if actionnable:
		score += 1
	else :
		anim.play("dead")
		life-=670*get_process_delta_time()

	print($Camera2D.zoom.x)
	if actionnable:
		life = min(life, 750)
		life-=50*get_process_delta_time()
		targetzoom = (1500/life - $Camera2D.zoom.x)/20
		if ($Camera2D.zoom.x < 10):
			$Camera2D.zoom.x += targetzoom
			$Camera2D.zoom.y += targetzoom
	else:
		print(zoom)
		var variable_avec_un_nom_correct = (2.6-$Camera2D.zoom.x)**3
		if ($Camera2D.zoom.x<=2.6) and zoom==true:
			$Camera2D.zoom.x+= 0.2 * delta * variable_avec_un_nom_correct
			$Camera2D.zoom.y+= 0.2 * delta * variable_avec_un_nom_correct

		elif ($Camera2D.zoom.x>=2.6) and zoom==false:
			$Camera2D.zoom.x-= 0.2 * delta * variable_avec_un_nom_correct * -1
			$Camera2D.zoom.y-= 0.2 * delta * variable_avec_un_nom_correct * -1

	
	if life<=1 and actionnable:
		lose()
	
	$PointLight2D.texture.width = life
	$PointLight2D.texture.height= life
	
	if Input.is_action_just_pressed("Quit"):
		get_tree().change_scene_to_file("res://Assets/Scenes/menu.tscn")

func _physics_process(delta: float) -> void:
	# Move player
	var move_dir = Vector2(Input.get_axis("Left","Right"), Input.get_axis("Up","Down"))
	if move_dir != Vector2.ZERO:
		anim.play("walking")
		velocity = move_dir * SPEED
	else:
		anim.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Shooting
	if Input.is_action_pressed("shoot") and actionnable and $FireCooldown.is_stopped():
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
			$FireCooldown.start()

	if actionnable:
		move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Battery") or body.is_in_group("LED") or body.is_in_group("Lightning")) and actionnable:
		body.queue_free()
		lose()


func lose():
	if ($Camera2D.zoom.x<=2.6):
		zoom=true
	actionnable = false
	$winlose_splash.position = Vector2(position.x, position.y-20)
	$winlose_splash/BoxContainer/Label.text= "%.2f seconds" % time_elapsed
	$winlose_splash/BoxContainer2/Label.text= "%s" % $/root/World.kills
	$winlose_splash.region_rect.position.x = 480
	$winlose_splash.visible = true
	$DeathFX.play()
