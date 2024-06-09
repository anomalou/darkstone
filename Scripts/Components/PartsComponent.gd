extends Node
class_name PartsComponent

enum Tag{
	MISSING,
	HEAD,
	UPPER_BODY,
	LEFT_ARM,
	RIGHT_ARM,
	GROIN,
	LEFT_LEG,
	RIGHT_LEG
}

@export var leading_hand = PartsComponent.Tag.RIGHT_ARM
var selected_arm = PartsComponent.Tag.RIGHT_ARM

func update_parts_direction(_direction):
	print_debug("Not implemented")
	pass

func attach_part(_part):
	print_debug("Not implemented")
	# attach missing part here
	pass

func detache_part(_part):
	print_debug("Not implemented")
	# detache body part here
	pass

func get_part(_part_tag) -> BodyPart:
	print_debug("Not implemented")
	return null

func get_parts():
	print_debug("Not implemented")
	pass

func cound_alive_parts():
	print_debug("Not implemented")
	pass

func do_brute_damage(_value : float, _target = PartsComponent.Tag.MISSING):
	print_debug("Not implemented")
	pass

func do_burn_damage(_value : float, _target = PartsComponent.Tag.MISSING):
	print_debug("Not implemented")
	pass

func get_brute_damage():
	print_debug("Not implemented")
	pass

func get_burn_damage():
	print_debug("Not implemented")
	pass

func get_slot(_tag) -> SlotComponent:
	print_debug("Not implemented")
	return null

func set_slot(_tag, _value):
	print_debug("Not implemented")
	pass

func has_vision():
	print_debug("Not implemented")
	pass
