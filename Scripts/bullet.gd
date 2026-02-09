extends Node2D

var explosion_scene = preload("res://Assets/Scenes/bullet_explosion.tscn")
var boots = preload("res://Assets/Scenes/bootsUpgrade.tscn")
var guns = preload("res://Assets/Scenes/bulletsUpgrade.tscn")
signal battery_killed
signal led_killed
signal tesla_killed
var mocked = false


@export var speed := 800.0
@onready var player = $/root/World/Player


var direction: Vector2 = Vector2.RIGHT
const SPEED = 600

func _ready():
	rotation = direction.angle()
	

func _physics_process(delta):
		position += direction * speed * delta

func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if mocked == false:
		if body.is_in_group("LED"):
			mockup($DiodeDeathFX)
			body.queue_free()
			emit_signal("led_killed",800)
			random_drop()
			explosion_fx()
			
		elif body.is_in_group("Obstacle"):
			explosion_fx()
			queue_free()
		
		elif body.is_in_group("Battery"):
			mockup($PileDeathFX)
			body.queue_free()
			emit_signal("battery_killed",800)
			random_drop()
			explosion_fx()
			
		elif body.is_in_group("Tesla"):
			mockup($TeslaDeathFX)
			body.queue_free()
			emit_signal("tesla_killed",400)
			random_drop()
			explosion_fx()
		
		elif body.is_in_group("Disjunktor"):
			$/root/World/Disjunktor.HP-=50
			if $/root/World/Disjunktor.HP <= 0 : 
				mockup($DisjunkDeathFX)
				body.get_parent().queue_free()
			else:
				mockup($DisjunkHitFX)
			explosion_fx()


func _on_battery_killed(_points) -> void:
	$/root/World/Player.life += 50

func _on_led_killed(_points) -> void:
	$/root/World/Player.life += 50
	
func _on_tesla_killed(_points) -> void:
	$/root/World/Player.life += 50

func random_drop():
	if randf() < 0.05:
		var drop = boots.instantiate()
		drop.global_position = global_position
		$/root/World.add_child(drop)
	elif randf() < 0.01:
		var drop = guns.instantiate()
		drop.global_position = global_position
		$/root/World.add_child(drop)

func explosion_fx():
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		explosion.emitting = true
		explosion.lifetime = randf_range(0.3, 0.7)
		$/root/World.add_child(explosion)

func mockup(audio: AudioStreamPlayer2D):
	mocked=true
	$Sprite2D.visible=false
	audio.play()


func _on_pile_death_fx_finished() -> void:
	queue_free()

func _on_diode_death_fx_finished() -> void:
	queue_free()

func _on_tesla_death_fx_finished() -> void:
	queue_free()

func _on_disjunk_hit_fx_finished() -> void:
	queue_free()

func _on_dis_junk_death_fx_finished() -> void:
	queue_free()
