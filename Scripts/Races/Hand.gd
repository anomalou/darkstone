extends BodyPart
class_name Hand

@export var hand_slot : SlotComponent

func update_direction(_direction):
	super(_direction)
	hand_slot.update_direction(_direction)

func get_hand_item():
	return hand_slot.get_item()

@rpc("any_peer", "call_local")
func take_item(item_path) -> bool:
	if hand_slot.item_path == null:
		return false
	
	hand_slot.set_slot(item_path)
	return true

func remove_item():
	hand_slot.remove_item()
