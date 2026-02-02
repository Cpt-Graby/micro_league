extends Node
@onready var player: CharacterBody3D = $Player_base
@onready var game_controler: Node = $"."
@onready var bot: CharacterBody3D = $champion_base_bot
@onready var end_message: Label = $end_message


@onready var timer = %game_timer
@onready var label: Label = %score
@onready var time_remaining: Label = %time_remaining

@onready var min_range_mesh: MeshInstance3D = %min_range_mesh
@onready var max_range_mesh: MeshInstance3D = %max_range_mesh

@export var min_distance: float = 10.0 
@export var max_distance: float = 15.0 

var score: float = 0.0
var scale_to_m = 2

func _ready():
	end_message.hide()
	#min_range_mesh.transform.scaled(Vector3(min_distance,0,min_distance))
	min_range_mesh.global_scale(Vector3(min_distance * scale_to_m, 0.2, min_distance * scale_to_m))
	max_range_mesh.global_scale(Vector3(max_distance * scale_to_m, 0.05, max_distance * scale_to_m))
	timer.start(60)


func _process(delta):
	
	var current_dist = player.global_position.distance_to(bot.global_position)
	if current_dist > min_distance and current_dist < max_distance:
		score += delta * 100
		label.text = "Score: " + str(int(score))
	var time = int(timer.get_time_left())
	time_remaining.text = "Time remaining: " + str(time)


func _on_game_timer_timeout():
	end_message.show()
	get_tree().paused = true
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scene/main_menu.tscn")
