extends NavigationRegion3D

# Configuration des vagues
var wave_number := 1
var units_per_wave := 1
var spawn_interval := 1.0  # en secondes
var wave_interval := 10.0  # en secondes

# Références aux points de spawn et cibles
@onready var spawn_blue: Marker3D = $Spawner_blue
@onready var spawn_red: Marker3D = $Spawner_red
@onready var target_red: Marker3D = $Target_red
@onready var target_blue: Marker3D = $Target_blue

# Précharge la scène de l'unité
var unit_scene := preload("res://scene/minion.tscn")

# Timer pour gérer les vagues et le spawn
var spawn_timer := 0.0
var wave_timer := 0.0
var current_wave_units := 0

func _ready():
	# Démarre la première vague
	#start_wave()
	spawn_unit()
	pass

func _process(delta):
	pass


func holder( delta):
		# Gestion du timer de spawn
	if current_wave_units < units_per_wave:
		spawn_timer += delta
		if spawn_timer >= spawn_interval:
			spawn_unit()
			spawn_timer = 0.0
	else:
		wave_timer += delta
		if wave_timer >= wave_interval:
			wave_number += 1
			start_wave()

func start_wave():
	current_wave_units = 0
	spawn_timer = 0.0
	wave_timer = 0.0
	print("Vague %d démarrée !" % wave_number)

func spawn_unit():
	current_wave_units += 1
	var unit := unit_scene.instantiate()
	# Choisis aléatoirement l'équipe (bleue ou rouge)
	var is_blue_team := randf() > 0.5
	unit.team = "blue" if is_blue_team else "red"
	# Positionne l'unité au bon point de spawn
	unit.global_transform.origin = spawn_blue.global_transform.origin if is_blue_team else spawn_red.global_transform.origin
	# Définit la cible de l'unité
	unit.target_position = target_blue.global_transform.origin if is_blue_team else target_red.global_transform.origin
	add_child(unit)
