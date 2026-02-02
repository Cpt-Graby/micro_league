extends Control

func _ready() -> void:
	if get_tree().paused:
		get_tree().paused = false

func _on_start_spacing_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/game_type/spacing_world.tscn")
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
