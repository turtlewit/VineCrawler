extends KinematicBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var sensitivity = 0.1

var max_speed = 20

var gravity = Vector3(0, -9.8, 0)
var linear_velocity = Vector3()

var accel = 19.0
var deaccel = 14.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_physics_process(true)

func _physics_process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	var lv=linear_velocity
	lv+=gravity * delta
	
	var up = transform.basis.y
	var vv = up.dot(lv)
	var hv = lv - up*vv
	
	var hspeed = hv.length()
	
	var dir = Vector3()
	if Input.is_action_pressed("move_forward"):
		dir += -transform.basis.z
	if Input.is_action_pressed("move_backward"):
		dir += transform.basis.z 
	if Input.is_action_pressed("move_left"):
		dir += -transform.basis.x 
	if Input.is_action_pressed("move_right"):
		dir += transform.basis.x 
	print(dir)
	var target_dir = (dir - up*dir.dot(up)).normalized()
	if is_on_floor():
		if dir.length() > 0.1:
			if (hspeed < max_speed):
					hspeed += accel*delta
		else:
			hspeed -= deaccel*delta
			if (hspeed < 0):
				hspeed = 0
				
		hv = dir.normalized()*hspeed
	else:
		var hs
		if (dir.length() > 0.1):
			hv += target_dir*(accel*0.2)*delta
			if (hv.length() > max_speed):
				hv = hv.normalized()*max_speed
	
	lv = hv + up*vv
	linear_velocity = move_and_slide(lv,up)


func _input(ev):
	if (ev is InputEventMouseMotion):
		rotate_y(-deg2rad(ev.relative.x) * sensitivity)