extends CharacterBody3D

const SPEED = 3.0
const JUMP_VELOCITY = 4.5
var target = Vector3.ZERO

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var camera_3D: Camera3D = $"../Camera3D"
@onready var ray_query = PhysicsRayQueryParameters3D.new()


var marker = preload("res://scene/marker.tscn")

func _ready():
	pass

func _physics_process(delta):
	var next_path_point = $NavigationAgent3D.get_next_path_position()
	var new_velocity = (next_path_point - global_position).normalized() * SPEED
	velocity.x = new_velocity.x
	velocity.z = new_velocity.z
	move_and_slide()

func _process(delta: float) -> void:
	camera_3D.global_position = $camera_marker.global_position
	camera_3D.look_at(transform.origin,Vector3.UP)
	pass

func create_instance(given_position: Vector3) -> void:
	var instance = marker.instantiate()
	instance.position = given_position
	$"..".add_child(instance)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("move_click"):
			move_to_click(event)
			
	if event.is_action_pressed("ui_accept"):
		var random_pos := Vector3.ZERO
		random_pos.x = randf_range(-2.5, 2.5)
		random_pos.z = randf_range(-2.5, 2.5)
		print("random_position: ", random_pos)
		navigation_agent.set_target_position(random_pos)


func move_to_click(event: InputEvent):
	var ray_length = 10000
	var space = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var from_mouse = camera_3D.project_ray_origin(mouse_pos)
	var to = from_mouse + camera_3D.project_ray_normal(mouse_pos) * ray_length
	
	ray_query.from = from_mouse
	ray_query.to = to
	var raycast_result = space.intersect_ray(ray_query)
	navigation_agent.set_target_position(raycast_result.position)
	print("raycast res: ", raycast_result)

	#var from = camera_3D.project_ray_origin(event.position)
	#var dir = camera_3D.project_local_ray_normal(event.position) 
	#var dir2 = camera_3D.project_local_ray_normal(event.position) * ray_length
	#var Cursor_pos = Plane(Vector3.UP, transform.origin.y).intersects_ray(from, dir)
	#var Cursor_pos2 = Plane(Vector3.UP, transform.origin.y).intersects_ray(from, dir2)
	#print("from: ", from, "-", from_mouse, " :from_mouse")

	#print("from: ",from)
	#print("to: ", dir)
	#print("dir: ", dir, "--- Cursor: ",Cursor_pos)
	#print("dir: ", dir2, "--- Cursor2: ",Cursor_pos2)
	#$NavigationAgent3D.target_position = Cursor_pos
	pass
