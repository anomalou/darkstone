extends RigidBody2D
class_name Item

@export var interaction_component : InteractionComponent
@export var throwable_component : ThrowableComponent
@export var sprite_component : ObjectSpriteComponent

var in_air : bool = false

func _physics_process(_delta):
	if in_air:
		if abs(linear_velocity) < 0.01:
			in_air = false

func get_sprite():
	return sprite_component.ground

@rpc("any_peer", "call_local")
func update_direction(_direction, mirror = false):
	sprite_component.mirror = mirror
	sprite_component.update_direction(_direction)

@rpc("any_peer", "call_local")
func set_equiped():
	sprite_component.set_in_hand.rpc(false)

@rpc("any_peer", "call_local")
func set_unequiped():
	sprite_component.set_in_hand.rpc(true)

@rpc("any_peer", "call_local")
func pick_up():
	sprite_component.set_on_ground.rpc(false)
	sprite_component.set_in_hand.rpc(true)
	interaction_component.hide()
	interaction_component.process_mode = Node.PROCESS_MODE_DISABLED
	position = Vector2.ZERO

@rpc("any_peer", "call_local")
func drop():
	sprite_component.set_on_ground.rpc(true)
	sprite_component.set_in_hand.rpc(true)
	interaction_component.show()
	interaction_component.process_mode = Node.PROCESS_MODE_PAUSABLE

@rpc("any_peer", "call_local")
func throw(direction):
	apply_impulse(direction)

@rpc("any_peer", "call_local")
func detach():
	set_multiplayer_authority(1)
