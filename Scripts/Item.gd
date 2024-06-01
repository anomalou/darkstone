extends Node2D
class_name Item

var is_equiped : bool = false

@export var interaction_component : InteractionComponent
@export var sprite_component : ObjectSpriteComponent

func _ready():
	update_sprite()

func get_sprite():
	return sprite_component.ground

func update_direction(_direction, mirror = false):
	sprite_component.mirror = mirror
	sprite_component.update_direction(_direction)

func set_equiped():
	is_equiped = true
	interaction_component.hide()
	interaction_component.process_mode = Node.PROCESS_MODE_DISABLED
	position = Vector2.ZERO
	
	update_sprite()

func set_unequiped():
	is_equiped = false
	interaction_component.show()
	interaction_component.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	update_sprite()

func update_sprite():
	sprite_component.on_ground = not is_equiped
