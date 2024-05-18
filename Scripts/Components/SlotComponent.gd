extends Node
class_name SlotComponent

var slot

func set_slot(value):
	slot = value
	return true

func get_slot():
	if not slot:
		return ""
	else:
		return slot
