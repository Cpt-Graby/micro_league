extends Champion

var timer_move : float = 0.0
var next_move_delay : float = 1.0 


func _ready():
	super._ready()
	type = "bot"
	stats = preload("res://data/sorakaData.tres")
	pass

func get_random_position(radius: float) -> Vector3:
	var random_x = randf_range(-radius, radius)
	var random_z = randf_range(-radius, radius)
	return Vector3(random_x, 0, random_z)


func _process(delta: float) -> void:
	physics_delta = delta
	timer_move += physics_delta
	if timer_move >= next_move_delay:
		print("New target")
		var new_position = get_random_position(10)
		navigation_agent.set_target_position(new_position)
		#print("velo: ",navigation_agent.velocity)
		#print("target_position: ", navigation_agent.target_position)
		timer_move = 0.0
		next_move_delay = randf_range(1.0, 4.0)
		#print(position)
	pass
