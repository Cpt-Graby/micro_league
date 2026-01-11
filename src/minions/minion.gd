extends CharacterBody3D

var team := ""  # "blue" ou "red"
var target_position := Vector3.ZERO
var walking = true
@export var movement_speed: float = 3.0

@onready var mesh_instance_3d: MeshInstance3D = $CollisionShape3D/MeshInstance3D
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var physics_delta: float

func _ready() -> void:
	print("team:", team)
	print("target_position", target_position)
	set_movement_target(target_position)
	print(navigation_agent.target_position)
	print(position)

	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)
	


func _physics_process(delta):
	if team == "":
		return
	physics_delta = delta
	
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		queue_free()
		return
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	global_position = global_position.move_toward(global_position + safe_velocity, physics_delta * movement_speed)
