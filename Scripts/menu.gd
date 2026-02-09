extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	$ButtonFX.play()
	get_tree().change_scene_to_file("res://Assets/Scenes/world.tscn")

func _on_options_pressed() -> void:
	$ButtonFX.play()

func _on_quit_pressed() -> void:
	$ButtonFX.play()
	get_tree().quit()
