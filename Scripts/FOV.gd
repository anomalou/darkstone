extends PointLight2D
class_name FOV

@onready var block_alpha : Sprite2D = $"BlockAlpha (beta)"

func update(size : Vector2):
	size = size / 512.0
	texture_scale = maxf(size.x, size.y)
	block_alpha.scale = size
