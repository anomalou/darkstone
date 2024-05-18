extends PartsComponent

@export var head : BodyPart

@export_group("Upper body")
@export var upper_body : BodyPart
@export var left_arm : BodyPart
@export var right_arm : BodyPart

@export_group("Groind")
@export var groin : BodyPart
@export var left_leg : BodyPart
@export var right_leg : BodyPart

func _part_wrap(part, callback : Callable):
	if part:
		return callback.call(part)

func get_part(tag : Part = Part.MISSING) -> BodyPart:
	match tag:
		Part.HEAD:
			return head
		Part.UPPER_BODY:
			return upper_body
		Part.LEFT_ARM:
			return left_arm
		Part.RIGHT_ARM:
			return right_arm
		Part.GROIN:
			return groin
		Part.LEFT_LEG:
			return left_leg
		Part.RIGHT_LEG:
			return right_leg
	
	return null

func get_parts() -> Array[BodyPart]:
	var parts : Array[BodyPart]
	
	if head:
		parts.append(head)
	if upper_body:
		parts.append(upper_body)
	if left_arm:
		parts.append(left_arm)
	if right_arm:
		parts.append(right_arm)
	if groin:
		parts.append(groin)
	if left_leg:
		parts.append(left_arm)
	if right_leg:
		parts.append(right_arm)
		
	return parts

func cound_alive_parts():
	var number : int = get_parts().size()
	return number

func _do_damage(callback, value : float, target : Part = Part.MISSING):
	var splash_damage : float = value / cound_alive_parts()
	
	match target:
		Part.HEAD:
			_part_wrap(head, func(p): p.call(callback, value))
		Part.UPPER_BODY:
			_part_wrap(upper_body, func(p): p.call(callback, value))
		Part.LEFT_ARM:
			_part_wrap(left_arm, func(p): p.call(callback, value))
		Part.RIGHT_ARM:
			_part_wrap(right_arm, func(p): p.call(callback, value))
		Part.GROIN:
			_part_wrap(groin, func(p): p.call(callback, value))
		Part.LEFT_LEG:
			_part_wrap(left_leg, func(p): p.call(callback, value))
		Part.RIGHT_LEG:
			_part_wrap(right_leg, func(p): p.call(callback, value))
		Part.MISSING:
			var parts = get_parts()
			for part in parts:
				_part_wrap(part, func(p): p.call(callback, value))

func do_brute_damage(value : float, target : Part = Part.MISSING):
	_do_damage("do_brute_damage", value, target)

func do_burn_damage(value : float, target : Part = Part.MISSING):
	_do_damage("do_burn_damage", value, target)

func get_brute_damage():
	var total : float = 0.0
	for part in get_parts():
		total += part.get_brute_damage()
	return total

func get_burn_damage():
	var total : float = 0.0
	for part in get_parts():
		total += part.get_burn_damage()
	return total

func get_slot(tag : Part) -> SlotComponent:
	match tag:
		Part.HEAD:
			return _part_wrap(head, func(p): p.get_slot())
		Part.UPPER_BODY:
			return _part_wrap(upper_body, func(p): p.get_slot())
		Part.LEFT_ARM:
			return _part_wrap(left_arm, func(p): p.get_slot())
		Part.RIGHT_ARM:
			return _part_wrap(right_arm, func(p): p.get_slot())
		Part.GROIN:
			return _part_wrap(groin, func(p): p.get_slot())
		Part.LEFT_LEG:
			return _part_wrap(left_leg, func(p): p.get_slot())
		Part.RIGHT_LEG:
			return _part_wrap(right_leg, func(p): p.get_slot())
	return null

func set_slot(tag : Part, value):
	match tag:
		Part.HEAD:
			_part_wrap(head, func(p): p.set_slot(value))
		Part.UPPER_BODY:
			_part_wrap(upper_body, func(p): p.set_slot(value))
		Part.LEFT_ARM:
			_part_wrap(left_arm, func(p): p.set_slot(value))
		Part.RIGHT_ARM:
			_part_wrap(right_arm, func(p): p.set_slot(value))
		Part.GROIN:
			_part_wrap(groin, func(p): p.set_slot(value))
		Part.LEFT_LEG:
			_part_wrap(left_leg, func(p): p.set_slot(value))
		Part.RIGHT_LEG:
			_part_wrap(right_leg, func(p): p.set_slot(value))
