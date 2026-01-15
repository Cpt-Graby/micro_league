extends CharacterBody3D

@export var movement_speed: float = 3.0
@onready var mesh_instance_3d: MeshInstance3D = $CollisionShape3D/MeshInstance3D
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
var physics_delta: float

# ALL MY BOOL
var debug_minion = true
var printed = false
var g_target_locked = false

# ALL THE CONST
const g_detection_range : float = 20.0

# tmp_var for test
var walking_to_target = false

# Running war 
var my_node : Node3D
var g_target_enemy : CharacterBody3D

# Standard value of minion 

var g_team := ""  # "blue" or "red"
var g_target_spawn := Vector3.ZERO
var g_heath :  int = 465
var g_attack_range : float = 1.500  
var g_attack_speed : float = 1.25
var g_attack_dmg : int = 21
var g_armor :float = 0
var g_magic_resit :float = 0

func _ready() -> void:
	my_node = get_node(".")
	add_to_group("minions")
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	set_movement_target(g_target_spawn)
	
	if debug_minion == true:
		print("g_team:", g_team)
		print("g_target_spawn: ", g_target_spawn)
		print(navigation_agent.target_position)
		print(position)


func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)


func _on_velocity_computed(safe_velocity: Vector3) -> void:
	global_position = global_position.move_toward(global_position + safe_velocity, physics_delta * movement_speed)


func dist_in_ranged_self(location_position: Vector3) -> float:
	var dist = sqrt((location_position.x - my_node.global_position.x)**2 + (location_position.z - my_node.global_position.z)**2)
	return dist


func get_index_closest_enemy(enemy_distance_list : Array)-> int:
	print(enemy_distance_list)
	if len(enemy_distance_list) == 0:
		return -1
	var index_closest : int = 0
	var min_dist = enemy_distance_list[0]
	for i in range(len(enemy_distance_list)):
		if enemy_distance_list[i] < min_dist:
			min_dist = enemy_distance_list[i]
			index_closest = i
	return index_closest


func _physics_process(delta):
	physics_delta = delta
	if g_team == "" or g_target_spawn == Vector3.ZERO:
		return
	
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	
	if g_target_locked == true:
		print("TARGET_LOCKED: ", g_target_enemy)
		print("dist: ", dist_in_ranged_self(g_target_enemy.position))
		if dist_in_ranged_self(g_target_enemy.position) <= g_attack_range:
			set_movement_target(global_position)
		else:
			set_movement_target(g_target_enemy.position)
	
		
	if navigation_agent.is_navigation_finished():
		print("Nav finished")
		return
	
	var dist_to_spawn_target = sqrt((g_target_spawn.x - global_position.x)**2 + (g_target_spawn.z - global_position.z)**2)
	if dist_to_spawn_target < .0:
		queue_free()
		return

	# Determining it we need to attack minion
	var all_minions = get_tree().get_nodes_in_group("minions")
	var minions_in_range_dist : Array
	var minions_in_range : Array
	for minion in all_minions:
		var dist_to_minion = dist_in_ranged_self(minion.position)
		if (minion != my_node and minion.g_team != my_node.g_team \
		and dist_to_minion <= g_detection_range):
			minions_in_range_dist.append(dist_to_minion)
			minions_in_range.append(minion)
	# Now we want to determine the if we have to set a target
	if len(minions_in_range) > 0:
		g_target_enemy = minions_in_range[get_index_closest_enemy(minions_in_range_dist)]
		g_target_locked = true
	
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
		#print("new_velocity set")
	else:
		_on_velocity_computed(new_velocity)
