extends Node2D
class_name Item

@export var interaction_component : InteractionComponent
@export var sprite_component : ObjectSpriteComponent

func get_sprite():
	return sprite_component.ground

func update_direction(_direction, mirror = false):
	sprite_component.mirror = mirror
	sprite_component.update_direction(_direction)

func set_equiped():
	pick_up()
	sprite_component.in_hand = false

func set_unequiped():
	drop()

func pick_up():
	sprite_component.on_ground = false
	sprite_component.in_hand = true
	interaction_component.hide()
	interaction_component.process_mode = Node.PROCESS_MODE_DISABLED
	position = Vector2.ZERO

func drop():
	sprite_component.on_ground = true
	sprite_component.in_hand = true
	interaction_component.show()
	interaction_component.process_mode = Node.PROCESS_MODE_PAUSABLE

