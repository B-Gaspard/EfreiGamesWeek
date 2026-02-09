extends CharacterBody2D

@onready var player = $/root/World/Player
@onready var timer = $Timer
@onready var light = $PointLight2D
var dead_led_scene = preload("res://Assets/Scenes/dead_led.tscn")

const FRAMES = 3
const SPEED = 80

func _ready() -> void:
	var random_index = randi_range(0,2)
	$Sprite2D.region_rect.position.x = random_index * 32
	match random_index:
		0: $PointLight2D.color=Color(255,0,0,255)
		1: $PointLight2D.color=Color(0,0,255,255)
		2: $PointLight2D.color=Color(0,255,0,255)

func _physics_process(delta: float) -> void:
	if timer.is_stopped():
		var random_number = randi_range(0,3)
		match random_number:
			0: position.x += 10
			1: position.x -= 10
			2: position.y += 10
			3: position.y -= 10
		timer.start()
	move_and_slide()

func _exit_tree() -> void:
	var dead_led = dead_led_scene.instantiate()
	dead_led.global_position = global_position
	dead_led.color = $PointLight2D.color
	$/root/World.add_child.call_deferred(dead_led)
