extends Node
class_name PartsComponent

enum Part {
	MISSING,
	HEAD,
	UPPER_BODY,
	LEFT_ARM,
	RIGHT_ARM,
	GROIN,
	LEFT_LEG,
	RIGHT_LEG
}

func attach_part(part):
	print_debug("Not implemented")
	# attach missing part here
	pass

func detache_part(part):
	print_debug("Not implemented")
	# detache body part here
	pass

func get_part(part_tag : Part) -> BodyPart:
	print_debug("Not implemented")
	return null

func get_parts():
	print_debug("Not implemented")
	pass

func cound_alive_parts():
	print_debug("Not implemented")
	pass

func do_brute_damage(value : float, target : Part = Part.MISSING):
	print_debug("Not implemented")
	pass

func do_burn_damage(value : float, target : Part = Part.MISSING):
	print_debug("Not implemented")
	pass

func get_brute_damage():
	print_debug("Not implemented")
	pass

func get_burn_damage():
	print_debug("Not implemented")
	pass

func get_slot(tag : Part) -> SlotComponent:
	print_debug("Not implemented")
	return null

func set_slot(tag : Part, value):
	print_debug("Not implemented")
	pass
