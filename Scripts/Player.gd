extends KinematicBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var sensitivity = 0.5
var mouse_movement = 0.0

var speed = 10

var gravity = Vector3(0, -9.8, 0)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_physics_process(true)

func _physics_process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	rotate(Vector3(0,1,0), -1 * sensitivity * mouse_movement * delta)
	mouse_movement = 0.0
	var dir = Vector3(0,0,0)
	if Input.is_action_pressed("move_forward"):
		dir += -transform.basis.z
	if Input.is_action_pressed("move_backward"):
		dir += transform.basis.z 
	if Input.is_action_pressed("move_left"):
		dir += -transform.basis.x 
	if Input.is_action_pressed("move_right"):
		dir += transform.basis.x 
	

		
	move_and_slide(dir.normalized() * speed, transform.basis.y)
	print(is_on_floor())
	if not is_on_floor():
		move_and_slide(gravity)

func _input(ev):
	if (ev is InputEventMouseMotion):
		mouse_movement = ev.relative.x