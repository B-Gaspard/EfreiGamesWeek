extends Sprite2D
var msg_sent=false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0
	$BoxContainer.position = Vector2($/root/World/Player.position.x-300, $/root/World/Player.position.y+100)
	$"../..".position=$/root/World/Player.position
	$/root/World/Player/Camera2D.zoom.x=2
	$/root/World/Player/Camera2D.zoom.y=2
	$BoxContainer/Label.text= "You survived %.2f seconds\nand killed %s enemies !" % [$/root/World/Player.time_elapsed, $/root/World.kills]
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	modulate.a += 0.55* delta
	if modulate.a >=1 and msg_sent==false:
		msg_sent=true
		$/root/World/Player.won=true
