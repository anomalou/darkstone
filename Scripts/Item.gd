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
	sprite_component.set_in_hand.rpc(false)

func set_unequiped():
	sprite_component.set_in_hand.rpc(true)

func pick_up():
	sprite_component.set_on_ground.rpc(false)
	sprite_component.set_in_hand.rpc(true)
	interaction_component.hide()
	interaction_component.process_mode = Node.PROCESS_MODE_DISABLED
	position = Vector2.ZERO

func drop():
	sprite_component.set_on_ground.rpc(true)
	sprite_component.set_in_hand.rpc(true)
	interaction_component.show()
	interaction_component.process_mode = Node.PROCESS_MODE_PAUSABLE

