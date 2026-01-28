extends CharacterBody3D
class_name Champion

const FINISH_RADIUS = 0.5
var walking = false
var physics_delta: float
var type : String


	# Standard value of minion 
var stats : ChampionData = preload("res://data/sorakaData.tres")
var g_team := ""  # "blue" or "red"
var g_health :  int = 465
var g_max_health: int = 465


@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var visuals: Node3D = $visuals
@onready var animation_player: AnimationPlayer = $visuals/player/AnimationPlayer


func _ready():
	type = "base"
	await get_tree().physics_frame
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	animation_player.play("idle")
	animation_player.set_blend_time("idle", "walk", 0.2)
	animation_player.set_blend_time("walk", "idle", 0.2)
	pass

func _on_velocity_computed(safe_velocity: Vector3):
	if safe_velocity != Vector3.ZERO:
		walking = true
		animation_player.play("walk")
	velocity = safe_velocity
	move_and_slide()


func _physics_process(delta):
	# Do not query when the map has never synchronized and is empty.
	physics_delta = delta
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		if abs(navigation_agent.target_position.x - global_position.x) > FINISH_RADIUS or abs(navigation_agent.target_position.z - global_position.z) > FINISH_RADIUS:
			if !walking:
				walking = true
				animation_player.play("walk")
			var direction = navigation_agent.target_position - global_position
			direction.y = 0
			velocity.x = direction.x * stats.ms
			velocity.y = 0
			velocity.z = direction.z * stats.ms
			move_and_slide()
		else:
			walking = false
			animation_player.play("idle")
		return
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * stats.ms
	if new_velocity.length():
		visuals.look_at(new_velocity + position )
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
