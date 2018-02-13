extends KinematicBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var player
var move_to_player = false
var visibility_length = 30
var touching_ground = false
var speed = 7.0
var gravity = 20.0
var linear_velocity = Vector3()

var health = 5

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player = get_node("/root/Scene/Player")
	set_physics_process(true)
	$sprite/AnimationPlayer.play("New Anim")

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if abs((player.translation - translation).length()) <= visibility_length:
		move_to_player = true
	else:
		move_to_player = false

func _physics_process(delta):
	if move_to_player:
		look_at(Vector3(player.translation.x, translation.y, player.translation.z), Vector3(0,1,0))
		if touching_ground:
			linear_velocity = -transform.basis.z * speed
			linear_velocity.y = 0.0
		else:
			linear_velocity.y -= gravity * delta
	else:
		if touching_ground:
			linear_velocity = Vector3()
		else:
			linear_velocity.y -= gravity * delta
	linear_velocity = move_and_slide(linear_velocity, Vector3(0,1,0))
	touching_ground = is_on_floor()

func on_hit(damage, knockback):
	health -= damage
	linear_velocity = (-transform.basis.z * -knockback) + Vector3(0, 7, 0)
	touching_ground = false
	if health <= 0:
		on_die()

func on_die():
	queue_free()
