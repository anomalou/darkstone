extends Node

@export var race : String

var blood_level : float
@export var max_blood_level : float = 100.0
var blood_group : String

var brute_damage : float
var burn_damage : float
var toxin_damage : float
var suff_damage : float # Suffocation damage

var temperature : float
var min_temperature : float
var max_temperature : float

var reagents : Dictionary # reagents in blood

var cached_parts : Dictionary


func _ready():
	if race != null:
		build_body()
	
func _process(delta):
	absorb_reagents(delta)
	process_injures(delta)
	
func _on_hit_area_input_event(_viewport, event : InputEvent, _shape_idx):
	if event.is_action_pressed("left_click"):
		# process hit here
		pass

func build_body():
	var race_data : Dictionary = RaceData.get_race(race)
	
	min_temperature = race_data["min_temperature"]
	max_temperature = race_data["max_temperature"]
	
	blood_level = max_blood_level
	blood_group = RaceData.blood_groups[randi_range(0, 3)]
	
	var upper_body = create_body_part(race_data, "upper_body")
	var groin = create_body_part(race_data, "groin")
	var head = create_body_part(race_data, "head")
	var left_arm = create_body_part(race_data, "left_arm")
	var right_arm = create_body_part(race_data, "right_arm")
	var left_leg = create_body_part(race_data, "left_leg")
	var right_leg = create_body_part(race_data, "right_leg")
	
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

func create_body_part(parts : Dictionary, part_name : String):
	var obj = RaceData.create_body_part()
	var data : Dictionary = parts[part_name]
	obj.name = part_name
	obj.texture_name = data["texture"]
	obj.size = data["size"]
	if data.has("organs"):
		for organ in create_organs(data["organs"]):
			obj.inject(organ)
	
	return obj

func create_organs(organs : Array):
	var pack : Array = []
	
	for organ : Dictionary in organs:
		var organ_obj = RaceData.create_organ()
		organ_obj.name = organ["name"]
		if organ.has("tags"):
			organ_obj.tags.append_array(organ["tags"])
		pack.append(organ_obj)
		
	return pack

func absorb_reagents(tick_coef):
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

func process_sorbent(sorbent, absorbed):
	# sorbent behaviour realization
	pass
	
func process_injures(tick_coef):
	if not get_part("upper_body").is_organ_alive_by_tag("heart"):
		suff_damage += tick_coef * 10
	if not get_part("upper_body").is_organ_alive_by_tag("lungs"):
		suff_damage += tick_coef * 10
	

func attach_part(part):
	# attach missing part here
	pass

func get_part(part : String):
	if part in cached_parts.keys():
		return cached_parts[part]
		

func get_body_status():
	# return final evaluation of body
	pass
