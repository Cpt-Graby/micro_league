extends CharacterBody3D

@export var movement_speed: float = 3.0
@onready var mesh_instance_3d: MeshInstance3D = $CollisionShape3D/MeshInstance3D
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var list_nod : Array
var printed = false

var unit_type := "" #'melee' or 'range'
var team := ""  # "blue" or "red"
var target_position := Vector3.ZERO
var walking = true
var physics_delta: float

func _ready() -> void:
	add_to_group("minions")
	#print("team:", team)
	#print("target_position", target_position)
	set_movement_target(target_position)
	#print(navigation_agent.target_position)
	#print(position)
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))




func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)


func _on_velocity_computed(safe_velocity: Vector3) -> void:
	global_position = global_position.move_toward(global_position + safe_velocity, physics_delta * movement_speed)


func _physics_process(delta):
	if team == "":
		return
	physics_delta = delta
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		queue_free()
		return
		
	var all_minions = get_tree().get_nodes_in_group("minions")
	if team == "red" and printed == false:
		for i in all_minions:
			print(i)
		printed = true
	
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
