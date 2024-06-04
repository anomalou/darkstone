extends BodyPart
class_name Hand

@export var hand_slot : SlotComponent

func update_direction(_direction):
	super(_direction)
	hand_slot.update_direction(_direction)

func get_hand_item():
	return hand_slot.get_item()

func get_hand_slot():
	return hand_slot

@rpc("any_peer", "call_local")
func take_item(item_path) -> bool:
	if hand_slot.item_path == null:
		return false
	
	hand_slot.set_slot(item_path)
	var item : Item = hand_slot.get_item()
	
	if item:
		item.pick_up()
		return true
	else:
		return false

func remove_item():
	hand_slot.remove_item()
