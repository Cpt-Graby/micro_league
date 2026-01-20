extends CharacterBody3D

const SPEED = 30.0
const JUMP_VELOCITY = 4.5
const FINISH_RADIUS = 0.8
var walking = false
var target_pos : Vector3 = Vector3.ZERO
var physics_delta: float

@onready var camera_3D: Camera3D = $"../Camera3D"
@onready var ray_query = PhysicsRayQueryParameters3D.new()
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var visuals: Node3D = $visuals
@onready var animation_player: AnimationPlayer = $visuals/player/AnimationPlayer

func _ready():
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	camera_3D.global_position = $camera_marker.global_position
	camera_3D.look_at(transform.origin,Vector3.UP)
	animation_player.play("idle")
	animation_player.set_blend_time("idle", "walk", 0.2)
	animation_player.set_blend_time("walk", "idle", 0.2)
	pass


func _on_navigation_agent_3d_target_reached() -> void:
	pass # Replace with function body.


func _physics_process(delta):
	# Do not query when the map has never synchronized and is empty.
	physics_delta = delta
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		if abs(target_pos.x - global_position.x) > FINISH_RADIUS or abs(target_pos.z - global_position.z) > FINISH_RADIUS:
			if !walking:
				walking = true
				animation_player.play("walk")
			var direction = target_pos - global_position
			direction.y = 0
			velocity.x = direction.x * SPEED
			velocity.y = 0
			velocity.z = direction.z * SPEED
			move_and_slide()
		else:
			walking = false
			animation_player.play("idle")
		return
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * SPEED
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
	camera_3D.global_position = $camera_marker.global_position
	camera_3D.look_at(transform.origin,Vector3.UP)
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("move_click"):
			move_to_click()


func move_to_click():
	var ray_length = 10000
	var space = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var from_mouse = camera_3D.project_ray_origin(mouse_pos)
	var to = from_mouse + camera_3D.project_ray_normal(mouse_pos) * ray_length
	ray_query.from = from_mouse
	ray_query.to = to
	var raycast_result = space.intersect_ray(ray_query)
	if (raycast_result.is_empty()):
		## TODO: find the intersection of the map and the last point
		return
	raycast_result.position.y = 0
	target_pos = raycast_result.position
	navigation_agent.set_target_position(raycast_result.position)
	pass
