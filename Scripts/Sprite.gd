extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var rtt

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	rtt = get_node("/root/Scene/Player/Viewport").get_texture()

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	rtt = get_node("/root/Scene/Player/Viewport").get_texture()
	set_texture(rtt)
