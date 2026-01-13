extends NavigationRegion3D

var wave_interval : float = 10.0  # en secondes
var unit_interval : float = 1.0
var time_spawn_next_wave : float

var unit_per_wave = 3

@onready var spawn_blue: Marker3D = $Spawner_blue
@onready var spawn_red: Marker3D = $Spawner_red
@onready var target_red: Marker3D = $Target_red
@onready var target_blue: Marker3D = $Target_blue

var unit_scene := preload("res://scene/minion.tscn")

func _ready():
	time_spawn_next_wave = 0.0
	pass


func _process(delta: float) -> void:
	if time_spawn_next_wave > 0.0:
		time_spawn_next_wave -= delta
	else:
		spawn_waves()
		time_spawn_next_wave = wave_interval
	pass


func basic_spawn_waves():
	spawn_unit("blue")
	spawn_unit("red")
	spawn_unit("blue")
	spawn_unit("red")
	spawn_unit("blue")
	spawn_unit("red")
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
	unit.team = team_color
	unit.global_transform.origin = spawn_blue.global_transform.origin if unit.team == "blue" else spawn_red.global_transform.origin
	unit.target_position = target_blue.global_transform.origin if unit.team == "blue" else target_red.global_transform.origin
	add_child(unit)
