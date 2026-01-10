extends CharacterBody3D

const SPEED = 3.0
const JUMP_VELOCITY = 4.5
var target = Vector3.ZERO

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var camera3D = $"../camera3D"

func debuging(message, value):
	print(message)
	print(value)
	print("---")
	pass

func _ready():
	print("hi there")
	pass

func _physics_process(delta):
	#debuging("transform", transform.origin)
	var next_path_point = $NavigationAgent3D.get_next_path_position()
	var new_velocity = (next_path_point - global_position).normalized() * SPEED
	velocity.x = new_velocity.x
	velocity.y = new_velocity.y
	move_and_slide()


func _process(delta: float) -> void:
	camera3D.global_position = $camera_marker.global_position
	#camera3D.look_at(transform.origin,Vector3.UP)
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("move_click"):
			print(event.global_position)
			print(event.position)
			move_to_click(event)


func move_to_click(event: InputEvent):
	var from = camera3D.project_ray_origin(event.position)
	var to = from + camera3D.project_local_ray_normal(event.position) * 1000
	print("from: ")
	print(from)
	print("to: ")
	print(to)
	print("---")
	print(Plane(Vector3.UP, transform.origin.y))
	
	var Cursor_pos = Plane(Vector3.UP, transform.origin.y).intersects_ray(from, to)
	if Cursor_pos == null:
		var rev_to = to * -1
		Cursor_pos = Plane(Vector3.UP, transform.origin.y).intersects_ray(from, rev_to)
	debuging("Cursor_pos", Cursor_pos)
	navigation_agent.target_position = Cursor_pos
	pass
