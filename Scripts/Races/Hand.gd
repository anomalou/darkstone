extends BodyPart
class_name Hand

@export var hand_slot : SlotComponent

@onready var root = get_node(Constants.network)

func update_direction(_direction):
	super(_direction)
	hand_slot.update_direction(_direction)

func get_hand_item():
	return hand_slot.get_item()

func get_hand_slot():
	return hand_slot

@rpc("any_peer", "call_local")
func take_item(item_path) -> bool:
	if hand_slot.is_empty() == null:
		return false
	
	hand_slot.set_slot.rpc(item_path)
	var item : Item = hand_slot.get_item()
	
	if item:
		item.pick_up()
		return true
	else:
		return false

@rpc("any_peer", "call_local")
func drop_item():
	var item : Item = hand_slot.get_item()
	
	if not item:
		return
	
	item.drop()
	
	item.set_multiplayer_authority(1)
	
	remove_item()

func remove_item():
	hand_slot.remove_item()
