extends Control

@onready var bar : TextureProgressBar = $Bar
@onready var animation : AnimationTree = $AnimationTree
@onready var sheduler : Sheduler = get_node(Constants.sheduler)

func _process(_delta):
	animation["parameters/conditions/close"] = not sheduler.in_progress
	animation["parameters/conditions/open"] = sheduler.in_progress
	
	if sheduler.in_progress:
		bar.value = float(sheduler.current_time) / float(sheduler.delay)
