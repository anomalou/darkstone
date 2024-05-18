extends SubViewport

@onready var fov : FOV = $FOV

func _ready():
	update()

func update():
	fov.update(size)
