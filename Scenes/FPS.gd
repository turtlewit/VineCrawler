extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var avg_fps = 0.0
var time_since_last_update = 0.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if time_since_last_update >= 0.5:
		set_text("%d" % round(1 / avg_fps))
		time_since_last_update = 0.0
		avg_fps = delta
	else:
		time_since_last_update += delta
		avg_fps = (avg_fps + delta) / 2
