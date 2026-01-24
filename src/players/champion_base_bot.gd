extends CharacterBody3D

const FINISH_RADIUS = 0.8
var walking = false
var target_pos : Vector3 = Vector3.ZERO
var physics_delta: float

	# Standard value of minion 
var g_team := ""  # "blue" or "red"
var g_movement_speed = 30.0
var g_target_spawn := Vector3.ZERO
var g_health :  int = 465
var g_max_health: int = 465
var g_attack_range : float = 2.500  
var g_attack_speed : float = 1.25
var g_attack_dmg : int = 21
var g_armor :float = 0
var g_magic_resit :float = 0
var g_time_last_attack = 0

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var visuals: Node3D = $visuals
@onready var animation_player: AnimationPlayer = $visuals/player/AnimationPlayer

func init_stats() -> void:
	# Standard value of minion 
	g_team = "blue"
	g_target_spawn = Vector3.ZERO
	g_health = 465
	g_max_health = 465
	g_attack_range = 2.500  
	g_attack_speed = 1.25
	g_attack_dmg = 21
	g_armor = 0
	g_magic_resit = 0
	g_time_last_attack = 0
	pass


func _ready():
	init_stats()
	global_position = Vector3.ZERO
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	animation_player.play("idle")
	animation_player.set_blend_time("idle", "walk", 0.2)
	animation_player.set_blend_time("walk", "idle", 0.2)
	init_stats()
	pass


func _on_navigation_agent_3d_target_reached() -> void:
	pass # Replace with function body.


func _physics_process(delta):
	# Do not query when the map has never synchronized and is empty.
	physics_delta = delta
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		animation_player.play("idle")
		return
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * g_movement_speed
	visuals.look_at(new_velocity + position)
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)


func _on_velocity_computed(safe_velocity: Vector3):
	if safe_velocity != Vector3.ZERO:
		walking = true
		animation_player.play("walk")
	velocity = safe_velocity
	move_and_slide()


func _process(delta: float) -> void:
	physics_delta = delta
	pass
