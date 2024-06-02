extends BodyPart
class_name BodyPartAccessory

@export var accessory_slot : SlotComponent

func update_direction(_direction):
	super(_direction)
	accessory_slot.update_direction(_direction)

func get_accessory_slot():
	return accessory_slot

@rpc("any_peer", "call_local")
func set_accessory_slot(item_path) -> bool:
	if accessory_slot.item_path != null:
		return false
	
	accessory_slot.set_slot(item_path)
	return true
