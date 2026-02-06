extends Champion

var target_pos : Vector3
	# Standard value of minion 
@onready var camera_3D: Camera3D = %Camera3D
@onready var ray_query = PhysicsRayQueryParameters3D.new()

func _ready():
	super._ready()
	stats = preload("res://data/sorakaData.tres")
	camera_3D.global_position = $camera_marker.global_position
	camera_3D.look_at(transform.origin,Vector3.UP)
	type = 'player'
	init_stats()
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("move_click"):
			move_to_click()
	if Input.is_action_just_pressed("stop_motion"):
		navigation_agent.set_target_position(position)


func init_stats() -> void:
	# Standard value of minion 
	g_team = "red"
	g_health = stats.hp
	target_pos = position
	pass


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
	if raycast_result.collider.is_in_group("minions"):
		print("J'ai cliqué sur un minion !")

	if raycast_result.collider.name == "Floor":
		raycast_result.position.y = 0
		target_pos = raycast_result.position
		navigation_agent.set_target_position(raycast_result.position)
	return


func _process(delta: float) -> void:
	physics_delta = delta
	camera_3D.global_position = $camera_marker.global_position
	camera_3D.look_at(transform.origin,Vector3.UP)
	pass
