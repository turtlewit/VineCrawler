extends KinematicBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var sensitivity = 0.1

var max_speed = 20

var gravity = Vector3(0, -9.8, 0)
var linear_velocity = Vector3()
var accel = 100.0
var deaccel = 100.0

var odir = Vector3() #old direction
var speed = 0.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_physics_process(true)

func _physics_process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	var lv = linear_velocity
	lv += gravity * delta
	var up = -gravity.normalized() # (up is against gravity)
	var vv = up.dot(lv) # Vertical velocity
	var hv = lv * Vector3(1,0,1)
	
	var dir = Vector3()
	
	if Input.is_action_pressed("move_forward"):
		dir += -transform.basis.z
	if Input.is_action_pressed("move_backward"):
		dir += transform.basis.z 
	if Input.is_action_pressed("move_left"):
		dir += -transform.basis.x 
	if Input.is_action_pressed("move_right"):
		dir += transform.basis.x 
	
	if dir.length() > 0:
		#odir = Vector3(lerp(odir.x, dir.x, .1),0,lerp(odir.z, dir.z, .1))
		odir = dir
	if true:
		if dir.length() >= 0.001:
			if speed <= max_speed:
				speed += accel * delta
			
			hv += odir.normalized() * ((max_speed - hv.length()) / max_speed) * accel * delta

			
		else:
			if speed > 0:
				speed -= deaccel * delta
			else:
				speed = 0
			var nhv = hv - odir.normalized() * deaccel * delta
			if nhv.length() < hv.length():
				hv -= odir.normalized() * deaccel * delta
			else:
				hv = Vector3(0,0,0)
	print(hv.length())
	lv = hv+up*vv
	
	linear_velocity = move_and_slide(lv)


func _input(ev):
	if (ev is InputEventMouseMotion):
		rotate_y(-deg2rad(ev.relative.x) * sensitivity)