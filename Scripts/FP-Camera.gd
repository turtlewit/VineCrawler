extends Camera

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var sensitivity = .1

var max_angle = 90

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	Input.set_mouse_mode(2)

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass


func _input(ev):
	if (ev is InputEventMouseMotion):
		var angle = rotation
		rotate_x(-deg2rad(ev.relative.y) * sensitivity)
		if (not (rotation.x <= deg2rad(max_angle) and rotation.x >= -deg2rad(max_angle))) or (rotation.z < -deg2rad(1) or rotation.z > deg2rad(1)):
			set("rotation", angle)