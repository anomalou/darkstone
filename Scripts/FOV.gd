extends PointLight2D
class_name FOV

@export var vision_percent : float = 1.0

@onready var block_alpha : Sprite2D = $"BlockAlpha (beta)"
@onready var animation : AnimationTree = $AnimationTree

func update(size : Vector2):
	size = size / 512.0
	texture_scale = maxf(size.x, size.y) * vision_percent
	block_alpha.scale = size

func close_eyes():
	animation["parameters/conditions/close"] = true
	animation["parameters/conditions/open"] = false

func open_eyes():
	animation["parameters/conditions/close"] = false
	animation["parameters/conditions/open"] = true
