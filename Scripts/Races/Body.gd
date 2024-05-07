extends Node

var body_name : String
@export var race : String

var blood_level : float
@export var max_blood_level : float = 100.0
var blood_group : String

var toxin_damage : float
var suff_damage : float # Suffocation damage

var temperature : float
var min_temperature : float
var max_temperature : float

var reagents : Dictionary # reagents in blood

var cached_parts : Dictionary

func _enter_tree():
	set_multiplayer_authority(name.split("_")[0].to_int())

func _ready():
	if race != null:
		_build_body()
	
func _process(delta):
	_absorb_reagents(delta)
	process_injures(delta)
	
func _on_hit_area_input_event(_viewport, event : InputEvent, _shape_idx):
	if event.is_action_pressed("examine"):
		pass
	elif event.is_action_pressed("left_click"):
		Signals.interact_with(self)

func _build_body():
	var race_data : Dictionary = RaceData.get_race(race)
	
	min_temperature = race_data["min_temperature"]
	max_temperature = race_data["max_temperature"]
	
	blood_level = max_blood_level
	blood_group = RaceData.blood_groups[randi_range(0, 3)]
	
	var upper_body = _create_body_part(race_data, "upper_body")
	var groin = _create_body_part(race_data, "groin")
	var head = _create_body_part(race_data, "head")
	var left_arm = _create_body_part(race_data, "left_arm")
	var right_arm = _create_body_part(race_data, "right_arm")
	var left_leg = _create_body_part(race_data, "left_leg")
	var right_leg = _create_body_part(race_data, "right_leg")
	
	# replace to append part method
	groin.add_child(left_leg)
	groin.add_child(right_leg)
	
	upper_body.add_child(head)
	upper_body.add_child(groin)
	upper_body.add_child(left_arm)
	upper_body.add_child(right_arm)
	
	add_child(upper_body)
	
#region Body part caching
	cached_parts["upper_body"] = upper_body
	cached_parts["groin"] = groin
	cached_parts["head"] = head
	cached_parts["left_arm"] = left_arm
	cached_parts["right_arm"] = right_arm
	cached_parts["left_leg"] = left_leg
	cached_parts["right_leg"] = right_leg
#endregion

func _create_body_part(parts : Dictionary, part_id : String):
	var obj = RaceData.create_body_part()
	var data : Dictionary = parts[part_id]
	obj.name = part_id
	obj.texture_name = RaceData.get_race_body_part_texture(race, part_id)
	obj.size = RaceData.get_race_body_part_size(race, part_id)
	var organs = RaceData.get_race_body_part_organs(race, part_id)
	if organs:
		for organ in _create_organs(organs):
			obj.inject(organ)
	
	return obj

func _create_organs(organs : Array):
	var pack : Array = []
	
	for organ : Dictionary in organs:
		var organ_obj = RaceData.create_organ()
		organ_obj.name = organ["id"]
		if organ.has("tags"):
			organ_obj.tags.append_array(organ["tags"])
		pack.append(organ_obj)
		
	return pack

func _absorb_reagents(tick_coef):
	for reagent in reagents:
		var absorbability = ReagentData.get_absorbability(reagent)
		var absorbed = absorbability * tick_coef
		reagents[reagent] = maxf(0, reagents[reagent] - absorbed)
		if reagents[reagent] == 0.0:
			reagents.erase(reagent)
		process_reagent(reagent, absorbed)

func process_reagent(reagent, absorbed):
	var tags = ReagentData.get_tags(reagent)
	if "blood" in tags:
		process_blood(reagent, absorbed)

# need move reagent behaviour to separated class
func process_blood(blood, absorbed):
	var tags = ReagentData.get_tags(blood)
	if blood_group in tags:
		blood_level = minf(max_blood_level, blood_level + absorbed)
	else:
		toxin_damage += absorbed * 1.5

# need move reagent behaviour to separated class
func process_sorbent(sorbent, absorbed):
	# sorbent behaviour realization
	pass

@warning_ignore("unused_parameter")
func process_injures(tick_coef):
	pass

func attach_part(part):
	# attach missing part here
	pass

func detache_part(part):
	# detache body part here
	pass

func get_part(part : String):
	if part in cached_parts.keys():
		return cached_parts[part]

func do_brute_damage(value : float, target : String = ""):
	var part = get_part(target)
	part.do_brute_damage(value)

func do_burn_damage(value : float, target : String = ""):
	var part = get_part(target)
	part.do_burn_damage(value)

func get_brute_damage():
	var total = 0.0
	for part in cached_parts.values():
		total += part.brute_damage
	return total

func get_burn_damage():
	var total = 0.0
	for part in cached_parts.values():
		total += part.burn_damage
	return total
