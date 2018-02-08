extends Camera

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var sensitivity = 0.5
var mouse_movement = 0.0

var max_angle = 80.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	Input.set_mouse_mode(2)

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	var angle = rotation_degrees
	rotate(Vector3(1,0,0), -1 * sensitivity * mouse_movement * delta)
	if (not (rotation_degrees.x <= max_angle and rotation_degrees.x >= -max_angle)) or (rotation_degrees.z < -1 or rotation_degrees.z > 1):
		set("rotation_degrees", angle)
	mouse_movement = 0.0


func _input(ev):
	if (ev is InputEventMouseMotion):
		mouse_movement = ev.relative.y
