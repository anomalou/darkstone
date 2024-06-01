extends Sprite2D
class_name BodyPartSpriteComponent

@export_group("Sprite direction")
@export var north : Texture2D
@export var west : Texture2D
@export var east : Texture2D
@export var south : Texture2D

var direction : Constants.Direction

func update_direction(_direction):
	direction = _direction

func _process(_delta):
	match direction:
		Constants.Direction.NORTH:
			texture = north
		Constants.Direction.WEST:
			texture = west
		Constants.Direction.EAST:
			texture = east
		Constants.Direction.SOUTH:
			texture = south
