extends Sprite2D
class_name ObjectSpriteComponent

@export var ground : Texture2D

@export_group("Equiped sprites", "equip_")
@export var equip_north : Texture2D
@export var equip_west : Texture2D
@export var equip_east : Texture2D
@export var equip_south : Texture2D

@export_group("Hand sprites", "hand_")
@export var hand_north : Texture2D
@export var hand_west : Texture2D
@export var hand_east : Texture2D
@export var hand_south : Texture2D

var direction : Constants.Direction
var mirror : bool = false
var on_ground : bool = true
var in_hand : bool = true

@rpc("any_peer", "call_local")
func set_on_ground(value):
	on_ground = value

@rpc("any_peer", "call_local")
func set_in_hand(value):
	in_hand = value

func update_direction(_direction, h_flip = false, v_flip = false):
	direction = _direction
	if not mirror:
		flip_h = h_flip
	else:
		flip_h = not h_flip
	flip_v = v_flip

func _process(_delta):
	if on_ground:
		texture = ground
	else:
		match  direction:
			Constants.Direction.NORTH:
				if in_hand:
					texture = hand_north
				else:
					texture = equip_north
			Constants.Direction.WEST:
				if in_hand:
					if not mirror:
						texture = hand_west
					else:
						texture = hand_east
				else:
					texture = equip_west
				
			Constants.Direction.EAST:
				if in_hand:
					if not mirror:
						texture = hand_east
					else:
						texture = hand_west
				else:
					texture = equip_east
			Constants.Direction.SOUTH:
				if in_hand:
					texture = hand_south
				else:
					texture = equip_south
