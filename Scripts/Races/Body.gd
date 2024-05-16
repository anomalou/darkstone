extends CharacterBody2D
class_name Body

enum BodyPartTag {
	MISSING,
	HEAD,
	UPPER_BODY,
	LEFT_ARM,
	RIGHT_ARM,
	GROIN,
	LEFT_LEG,
	RIGHT_LEG
}

@export var name_component : NameComponent

@export var blood_component : BloodComponent

@export var toxin_damage : DamageComponent
@export var suff_damage : DamageComponent # Suffocation damage

@export var state_component : StateComponent
@export var velocity_component : VelocityComponent

var temperature : float
var min_temperature : float
var max_temperature : float

var reagents : Dictionary # reagents in blood

@export var partsRoot : Node

@onready var animation : AnimationTree = $AnimationTree

func _enter_tree():
	set_multiplayer_authority(name.split("_")[0].to_int())

func _ready():
	animation.active = true

func _process(delta):
	_process_animation()
	
	if not is_multiplayer_authority():
		return
	state_component.calculate(self)

func _physics_process(_delta):
	if not state_component.is_dead:
		velocity_component.move(self)

func _process_animation():
	if velocity != Vector2.ZERO:
		animation["parameters/conditions/walk"] = true
		animation["parameters/conditions/idle"] = false
	else:
		animation["parameters/conditions/walk"] = false
		animation["parameters/conditions/idle"] = true
	
	animation["parameters/conditions/fell"] = in_critical() or is_dead()
	animation["parameters/conditions/stand_up"] = not in_critical() and not is_dead()

#func _absorb_reagents(tick_coef):
	#for reagent in reagents:
		#var absorbability = ReagentData.get_absorbability(reagent)
		#var absorbed = absorbability * tick_coef
		#reagents[reagent] = maxf(0, reagents[reagent] - absorbed)
		#if reagents[reagent] == 0.0:
			#reagents.erase(reagent)
		#process_reagent(reagent, absorbed)

#func process_reagent(reagent, absorbed):
	#var tags = ReagentData.get_tags(reagent)
	#if "blood" in tags:
		#process_blood(reagent, absorbed)

# need move reagent behaviour to separated class
#func process_blood(blood, absorbed):
	#var tags = ReagentData.get_tags(blood)
	#if blood_group in tags:
		#blood_level = minf(max_blood_level, blood_level + absorbed)
	#else:
		#toxin_damage += absorbed * 1.5

# need move reagent behaviour to separated class
func process_sorbent(sorbent, absorbed):
	# sorbent behaviour realization
	pass

@warning_ignore("unused_parameter")
func process_injures(tick_coef):
	pass

func is_dead():
	return state_component.is_dead

func in_critical():
	return state_component.in_critical

func attach_part(part):
	# attach missing part here
	pass

func detache_part(part):
	# detache body part here
	pass

func get_part(part_tag : BodyPartTag) -> BodyPart:
	for part in partsRoot.get_children():
		if part.tag == part_tag:
			return part
	return null

func get_parts():
	var parts : Array
	for part in partsRoot.get_children():
		parts.append(part)
	return parts

@rpc("any_peer", "call_local")
func do_brute_damage(value : float, target : BodyPartTag = BodyPartTag.MISSING):
	for part in partsRoot.get_children():
		if target == BodyPartTag.MISSING:
			part.do_brute_damage(value / float(partsRoot.get_child_count()))
		elif part.tag == target:
			part.do_brute_damage(value)

@rpc("any_peer", "call_local")
func do_burn_damage(value : float, target : BodyPartTag = BodyPartTag.MISSING):
	for part in partsRoot.get_children():
		if target == BodyPartTag.MISSING:
			part.do_burn_damage(value / float(partsRoot.get_child_count()))
		elif part.tag == target:
			part.do_burn_damage(value)

@rpc("any_peer", "call_local")
func do_toxin_damage(value : float):
	toxin_damage.damage(value)

@rpc("any_peer", "call_local")
func do_suff_damage(value : float):
	suff_damage.damage(value)

func get_brute_damage():
	var total = 0.0
	for part in partsRoot.get_children():
		if part is BodyPart:
			total += part.get_brute_damage()
	return total

func get_burn_damage():
	var total = 0.0
	for part in partsRoot.get_children():
		if part is BodyPart:
			total += part.get_burn_damage()
	return total

func get_toxin_damage():
	return toxin_damage.damage_value

func get_suff_damage():
	return suff_damage.damage_value

func get_total_damage():
	return get_brute_damage() + get_burn_damage() + get_toxin_damage() + get_suff_damage()

func get_slot(part_tag : BodyPartTag) -> SlotComponent:
	for part in partsRoot.get_children():
		if part is BodyPart and part.tag == part_tag:
			return part.get_slot()
	return null

@rpc("any_peer", "call_local")
func set_slot(part_tag : BodyPartTag, value):
	for part in partsRoot.get_children():
		if part is BodyPart and part.tag == part_tag:
			return part.set_slot(value)
	return false
