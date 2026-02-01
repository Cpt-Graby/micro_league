extends Node

@onready var player: CharacterBody3D = $"../Player_base"
@onready var game_controler: Node = $"."
@onready var bot: CharacterBody3D = $"../champion_base_bot"

@export var min_distance: float = 5.0  
@export var max_distance: float = 15.0 

var score: float = 0.0
var time_left: float = 5.0
var game_over: bool = false

@onready var timer = $game_timer

func _ready():
	timer.start(5)

func _process(delta):
	if game_over:
		return
	var current_dist = player.global_position.distance_to(bot.global_position)

	if current_dist > min_distance and current_dist < max_distance:
		score += delta * 100 
	#else:
	#	score -= delta * 50
	time_left = timer.time_left

func _on_game_timer_timeout():
	print("timeout")
	game_over = true
	
	present_results()

func present_results():
	var result_scene = load("res://scene/game_type/spacing_result.tscn").instantiate()
	add_child(result_scene)
	#result_scene.set_score(score)
   
	print("Temps écoulé !")
	print("Score final : ", int(score))
	game_over = true
	# Ici, vous pouvez afficher un CanvasLayer avec le score
