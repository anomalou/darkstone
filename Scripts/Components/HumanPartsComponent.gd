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

func update_parts_direction(_direction):
	_part_wrap(head, func(p): p.update_direction(_direction))
	_part_wrap(upper_body, func(p): p.update_direction(_direction))
	_part_wrap(left_arm, func(p): p.update_direction(_direction))
	_part_wrap(right_arm, func(p): p.update_direction(_direction))
	_part_wrap(groin, func(p): p.update_direction(_direction))
	_part_wrap(left_leg, func(p): p.update_direction(_direction))
	_part_wrap(right_leg, func(p): p.update_direction(_direction))

func get_part(tag = PartsComponent.Tag.MISSING) -> BodyPart:
	match tag:
		PartsComponent.Tag.HEAD:
			return head
		PartsComponent.Tag.UPPER_BODY:
			return upper_body
		PartsComponent.Tag.LEFT_ARM:
			return left_arm
		PartsComponent.Tag.RIGHT_ARM:
			return right_arm
		PartsComponent.Tag.GROIN:
			return groin
		PartsComponent.Tag.LEFT_LEG:
			return left_leg
		PartsComponent.Tag.RIGHT_LEG:
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

func _do_damage(callback, value : float, target = PartsComponent.Tag.MISSING):
	var splash_damage : float = value / cound_alive_parts()
	
	match target:
		PartsComponent.Tag.HEAD:
			_part_wrap(head, func(p): p.call(callback, value))
		PartsComponent.Tag.UPPER_BODY:
			_part_wrap(upper_body, func(p): p.call(callback, value))
		PartsComponent.Tag.LEFT_ARM:
			_part_wrap(left_arm, func(p): p.call(callback, value))
		PartsComponent.Tag.RIGHT_ARM:
			_part_wrap(right_arm, func(p): p.call(callback, value))
		PartsComponent.Tag.GROIN:
			_part_wrap(groin, func(p): p.call(callback, value))
		PartsComponent.Tag.LEFT_LEG:
			_part_wrap(left_leg, func(p): p.call(callback, value))
		PartsComponent.Tag.RIGHT_LEG:
			_part_wrap(right_leg, func(p): p.call(callback, value))
		PartsComponent.Tag.MISSING:
			var parts = get_parts()
			for part in parts:
				_part_wrap(part, func(p): p.call(callback, value))

func do_brute_damage(value : float, target = PartsComponent.Tag.MISSING):
	_do_damage("do_brute_damage", value, target)

func do_burn_damage(value : float, target = PartsComponent.Tag.MISSING):
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

func get_slot(tag) -> SlotComponent:
	match tag:
		PartsComponent.Tag.HEAD:
			return _part_wrap(head, func(p): return p.get_slot())
		PartsComponent.Tag.UPPER_BODY:
			return _part_wrap(upper_body, func(p): return p.get_slot())
		PartsComponent.Tag.LEFT_ARM:
			return _part_wrap(left_arm, func(p): return p.get_slot())
		PartsComponent.Tag.RIGHT_ARM:
			return _part_wrap(right_arm, func(p): return p.get_slot())
		PartsComponent.Tag.GROIN:
			return _part_wrap(groin, func(p): return p.get_slot())
		PartsComponent.Tag.LEFT_LEG:
			return _part_wrap(left_leg, func(p): return p.get_slot())
		PartsComponent.Tag.RIGHT_LEG:
			return _part_wrap(right_leg, func(p): return p.get_slot())
	return null

func set_slot(tag, value):
	match tag:
		PartsComponent.Tag.HEAD:
			_part_wrap(head, func(p): p.set_slot(value))
		PartsComponent.Tag.UPPER_BODY:
			_part_wrap(upper_body, func(p): p.set_slot(value))
		PartsComponent.Tag.LEFT_ARM:
			_part_wrap(left_arm, func(p): p.set_slot(value))
		PartsComponent.Tag.RIGHT_ARM:
			_part_wrap(right_arm, func(p): p.set_slot(value))
		PartsComponent.Tag.GROIN:
			_part_wrap(groin, func(p): p.set_slot(value))
		PartsComponent.Tag.LEFT_LEG:
			_part_wrap(left_leg, func(p): p.set_slot(value))
		PartsComponent.Tag.RIGHT_LEG:
			_part_wrap(right_leg, func(p): p.set_slot(value))
