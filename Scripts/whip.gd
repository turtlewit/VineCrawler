extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var anim_player
var ray_length = 7
var camera
var has_attacked = false
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	anim_player = $AnimationPlayer
	camera = get_parent()

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	if Input.is_action_just_pressed("attack"):
		has_attacked = false
		anim_player.play("Attack")
		
	else:
		if !anim_player.is_playing():
			anim_player.play("Idle")
	
	if anim_player.current_animation == "Attack" and anim_player.current_animation_position >= 0.2 and !has_attacked:
		attack()
		has_attacked = true

func attack():
	var from = camera.global_transform.origin
	var to = from + -camera.global_transform.basis.z * ray_length
	var space_state = get_world().get_direct_space_state()
	
	var result = space_state.intersect_ray(from, to)
	if not result.empty():
		if result.collider.name == "enemy":
			var distance = abs((camera.global_transform.origin - (result.collider.translation + Vector3(0,1,0) * camera.global_transform.origin.y)).length())
			result.collider.on_hit(1, 10 * (ray_length / distance))
