extends SubViewport

@onready var fov : FOV = $FOV

func _process(delta):
	update()

func update():
	fov.update(size)
