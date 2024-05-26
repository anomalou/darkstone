extends Sprite2D
class_name SpriteComponent

@export var ground : Texture2D

@export_group("Direction sprites")
@export var north : Texture2D
@export var west : Texture2D
@export var east : Texture2D
@export var south : Texture2D

var direction
var on_ground : bool = false

func update_direction(_direction):
	direction = _direction

func _process(delta):
	if on_ground:
		texture = ground
	else:
		match  direction:
			Constants.Direction.NORTH:
				texture = north
			Constants.Direction.WEST:
				texture = west
			Constants.Direction.EAST:
				texture = east
			Constants.Direction.SOUTH:
				texture = south
