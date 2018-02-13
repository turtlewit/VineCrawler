extends KinematicBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var cmd = {
	forward_move 	= 0.0,
	right_move 		= 0.0,
	up_move 		= 0.0
}

var player_view
var player_view_y_offset = 0.4
var x_mouse_sensitivity = 0.1
var y_mouse_sensitivity = 0.1

var gravity = 20

var friction = 6.0

var move_speed = 15.0
var run_acceleration = 14.0
var run_deacceleration = 10.0
var air_acceleration = 2.0
var air_deacceleration = 2.0
var air_control = 0.3
var side_strafe_acceleration = 50.0
var side_strafe_speed = 1.0
var jump_speed = 8.0
var move_scale = 1.0

var rot_x = 0.0
var rot_y = 0.0

var move_direction_norm = Vector3()
var player_velocity = Vector3()
var player_top_velocity = 0.0

var wish_jump = false;

var touching_ground = false;

var player_friction = 0.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_physics_process(true)
	player_view = $Player_Camera
	#player_view.translation = Vector3(
	#	translation.x, 
	#	translation.y, 
	#	translation.z
	#)
	
	#_controller is self

#func _physics_process(delta):
	

func _physics_process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	queue_jump()
	if touching_ground:
		ground_move(delta)
	else:
		air_move(delta)
	
	player_velocity = move_and_slide(player_velocity, Vector3(0,1,0))
	touching_ground = is_on_floor()
	

	
	#player_view.transform.origin = Vector3(
	#	transform.origin.x, 
	#	transform.origin.y, 
	#	transform.origin.z
	#)

func set_movement_dir():
	cmd.forward_move = 0.0
	cmd.right_move = 0.0
	if Input.is_action_pressed("move_forward"):
		cmd.forward_move = 1.0
	if Input.is_action_pressed("move_backward"):
		cmd.forward_move = -1.0
	if Input.is_action_pressed("move_left"):
		cmd.right_move = -1.0
	if Input.is_action_pressed("move_right"):
		cmd.right_move = 1.0

func queue_jump():
	if Input.is_action_just_pressed("jump") and !wish_jump:
		wish_jump = true
	if Input.is_action_just_released("jump"):
		wish_jump = false

func air_move(delta):
	var wishdir = Vector3()
	var wishvel = air_acceleration
	var accel = 0.0
	
	var scale = cmd_scale()
	
	set_movement_dir()
	
	#wishdir = Vector3(cmd.right_move, 0, cmd.forward_move)
	if cmd.right_move > 0:
		wishdir += transform.basis.x
	elif cmd.right_move < 0:
		wishdir -= transform.basis.x
	if cmd.forward_move > 0:
		wishdir -= transform.basis.z
	elif cmd.forward_move < 0:
		wishdir += transform.basis.z
	
	var wishspeed = wishdir.length()
	wishspeed *= move_speed
	
	
	wishdir = wishdir.normalized()
	move_direction_norm = wishdir
	#wishspeed *= scale
	
	
	var wishspeed2 = wishspeed
	if player_velocity.dot(wishdir) < 0:
		accel = air_deacceleration
	else:
		accel = air_acceleration
	
	if(cmd.forward_move == 0) and (cmd.right_move != 0):
		if wishspeed > side_strafe_speed:
			wishspeed = side_strafe_speed
		accel = side_strafe_acceleration
		
	accelerate(wishdir, wishspeed, accel, delta)
	if air_control > 0:
		air_control(wishdir, wishspeed2, delta)
		
	player_velocity.y -= gravity * delta

func air_control(wishdir, wishspeed, delta):
	var zspeed = 0.0
	var speed = 0.0
	var dot = 0.0
	var k = 0.0
	
	if (abs(cmd.forward_move) < 0.001) or (abs(wishspeed) < 0.001):
		return
	zspeed = player_velocity.y
	player_velocity.y = 0
	
	speed = player_velocity.length()
	player_velocity = player_velocity.normalized()
	
	dot = player_velocity.dot(wishdir)
	k = 32.0
	k *= air_control * dot * dot * delta
	
	if dot > 0:
		player_velocity.x = player_velocity.x * speed + wishdir.x * k
		player_velocity.y = player_velocity.y * speed + wishdir.y * k 
		player_velocity.z = player_velocity.z * speed + wishdir.z * k 
		
		player_velocity = player_velocity.normalized()
		move_direction_norm = player_velocity
	
	player_velocity.x *= speed 
	player_velocity.y = zspeed #note i guess
	player_velocity.z *= speed 

func ground_move(delta):
	var wishdir = Vector3()
	
	if (!wish_jump):
		apply_friction(1.0, delta)
	else:
		apply_friction(0, delta)
	
	set_movement_dir()
	
	var scale = cmd_scale()
	
	#wishdir = Vector3()
	if cmd.right_move > 0:
		wishdir += transform.basis.x
	elif cmd.right_move < 0:
		wishdir -= transform.basis.x
	if cmd.forward_move > 0:
		wishdir -= transform.basis.z
	elif cmd.forward_move < 0:
		wishdir += transform.basis.z
	wishdir = wishdir.normalized()
	move_direction_norm = wishdir
	
	var wishspeed = wishdir.length()
	wishspeed *= move_speed
	
	accelerate(wishdir, wishspeed, run_acceleration, delta)
	
	player_velocity.y = 0.0
	
	if wish_jump:
		player_velocity.y = jump_speed
		wish_jump = false

func apply_friction(t, delta):
	var vec = player_velocity
	var speed = 0.0
	var newspeed = 0.0
	var control = 0.0
	var drop = 0.0
	
	vec.y = 0.0
	speed = vec.length()
	drop = 0.0
	
	if touching_ground:
		if speed < run_deacceleration:
			control = run_deacceleration
		else:
			control = speed
		drop = control * friction * delta * t
	
	newspeed = speed - drop;
	player_friction = newspeed
	if newspeed < 0:
		newspeed = 0
	if speed > 0:
		newspeed /= speed
	
	player_velocity.x *= newspeed
	player_velocity.z *= newspeed

func accelerate(wishdir, wishspeed, accel, delta):
	var addspeed = 0.0
	var accelspeed = 0.0
	var currentspeed = 0.0
	
	currentspeed = player_velocity.dot(wishdir)
	addspeed = wishspeed - currentspeed
	if addspeed <=0:
		return
	accelspeed = accel * delta * wishspeed
	if accelspeed > addspeed:
		accelspeed = addspeed
	
	player_velocity.x += accelspeed * wishdir.x
	player_velocity.z += accelspeed * wishdir.z

func cmd_scale():
	var var_max = 0
	var total = 0.0
	var scale = 0.0
	
	var_max = int(abs(cmd.forward_move))
	if(abs(cmd.right_move) > var_max):
		var_max = int(abs(cmd.right_move))
	if var_max <= 0:
		return 0
	
	total = sqrt(cmd.forward_move * cmd.forward_move + cmd.right_move * cmd.right_move)
	scale = move_speed * var_max / (move_scale * total)
	
	return scale

func _input(ev):
	if (ev is InputEventMouseMotion):
		rotate_y(-deg2rad(ev.relative.x) * y_mouse_sensitivity)