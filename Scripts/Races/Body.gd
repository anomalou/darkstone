extends CharacterBody2D
class_name Body

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

var in_critical : bool = false
var in_coma : bool = false
var in_sleep : bool = false

var cached_parts : Dictionary

@onready var animation : AnimationTree = $AnimationTree

func _enter_tree():
	set_multiplayer_authority(name.split("_")[0].to_int())

func _ready():
	animation.active = true
	
	if race != null:
		_build_body()
	
func _process(delta):
	_process_animation()
	
	_absorb_reagents(delta)
	process_injures(delta)

func _physics_process(_delta):
	pass

func _process_animation():
	if velocity != Vector2.ZERO:
		animation["parameters/conditions/walk"] = true
		animation["parameters/conditions/idle"] = false
	else:
		animation["parameters/conditions/walk"] = false
		animation["parameters/conditions/idle"] = true
	
	animation["parameters/conditions/fell"] = in_critical or in_coma or in_sleep
	animation["parameters/conditions/stand_up"] = not in_critical and not in_coma and not in_sleep

func _on_hit_area_input_event(_viewport, event : InputEvent, _shape_idx):
	if event.is_action_pressed("examine"):
		pass
	elif event.is_action_pressed("left_click"):
		Signals.interact.emit(self)

func _build_body():
	min_temperature = RaceData.get_race_body_min_temperature(race)
	max_temperature = RaceData.get_race_body_max_temperature(race)
	
	blood_level = max_blood_level
	blood_group = RaceData.blood_groups[randi_range(0, 3)]
	
	var upper_body = _create_body_part("upper_body")
	var groin = _create_body_part("groin")
	var head = _create_body_part("head")
	var left_arm = _create_body_part("left_arm")
	var right_arm = _create_body_part("right_arm")
	var left_leg = _create_body_part("left_leg")
	var right_leg = _create_body_part("right_leg")
	
	# replace to append part method
	groin.add_child(left_leg)
	groin.add_child(right_leg)
	
	upper_body.add_child(head)
	upper_body.add_child(groin)
	upper_body.add_child(left_arm)
	upper_body.add_child(right_arm)
	
	$Parts.add_child(upper_body)
	
#region Body part caching
	cached_parts["upper_body"] = upper_body
	cached_parts["groin"] = groin
	cached_parts["head"] = head
	cached_parts["left_arm"] = left_arm
	cached_parts["right_arm"] = right_arm
	cached_parts["left_leg"] = left_leg
	cached_parts["right_leg"] = right_leg
#endregion

func _create_body_part(part_id : String):
	var obj = RaceData.create_body_part()
	
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

@rpc("any_peer", "call_local")
func do_brute_damage(value : float, target : String = ""):
	if target == "":
		for part in cached_parts.values():
			part.do_brute_damage(value)
	else:
		var part = get_part(target)
		part.do_brute_damage(value)

@rpc("any_peer", "call_local")
func set_critical(value):
	in_critical = value

@rpc("any_peer", "call_local")
func do_burn_damage(value : float, target : String = ""):
	if target == "":
		for part in cached_parts.values():
			part.do_burn_damage(value)
	else:
		var part = get_part(target)
		part.do_burn_damage(value)

@rpc("any_peer", "call_local")
func do_toxin_damage(value : float):
	toxin_damage += value

@rpc("any_peer", "call_local")
func do_suff_damage(value : float):
	suff_damage += value

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

func get_slot(slot_name):
	if cached_parts.has(slot_name):
		return cached_parts[slot_name].get_slot()

@rpc("any_peer", "call_local")
func set_slot(slot_name, value):
	if cached_parts.has(slot_name):
		cached_parts[slot_name].set_slot(value)
		return true
	return false

func is_alive():
	if not cached_parts.has("head"):
		return false
