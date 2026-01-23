extends NavigationRegion3D

var wave_interval : float = 30.0  # en secondes
var unit_interval : float = 1.0
var time_spawn_next_wave : float

var unit_per_wave = 2

@onready var spawn_blue: Marker3D = $Spawner_blue
@onready var spawn_red: Marker3D = $Spawner_red 
var target_red : Vector3 
var target_blue : Vector3



var unit_scene := preload("res://scene/minions/minion.tscn")

func _ready():
	target_blue = spawn_red.global_position
	target_red = spawn_blue.global_position
	print("target_blue:", target_blue)
	time_spawn_next_wave = 0.0
	pass


func _process(delta: float) -> void:
	if time_spawn_next_wave > 0.0:
		time_spawn_next_wave -= delta
	else:
		spawn_waves()
		time_spawn_next_wave = wave_interval
	pass


func spawn_waves()->void:
	var unit_spwan = unit_per_wave
	while unit_spwan > 0:
		spawn_unit("blue")
		spawn_unit("red")
		unit_spwan -= 1
		await get_tree().create_timer(unit_interval).timeout
	pass


func spawn_unit(team_color : String) -> void:
	var unit := unit_scene.instantiate()
	unit.g_team = team_color
	unit.g_target_spawn = target_blue if unit.g_team == "blue" else target_red
	print("spawn_unit: ", target_blue)
	print("g_target_spawn: ", unit.g_target_spawn)

	unit.position = spawn_blue.global_transform.origin if unit.g_team == "blue" else spawn_red.global_transform.origin

	add_child(unit)
