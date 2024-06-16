extends RigidBody2D
class_name Body

@export var name_component : NameComponent

@export var blood_component : BloodComponent

@export var toxin_damage : DamageComponent
@export var suff_damage : DamageComponent # Suffocation damage

@export var parts_component : PartsComponent
@export var state_component : StateComponent
@export var control_component : ControlComponent
@export var velocity_component : VelocityComponent

var temperature : float
var min_temperature : float
var max_temperature : float

var reagents : Dictionary # reagents in blood

@onready var animation : AnimationTree = $AnimationTree
@onready var fov : FOV = get_node(Constants.fov)

func _enter_tree():
	set_multiplayer_authority(name.split("_")[0].to_int())

func _ready():
	animation.active = true

func _process(_delta):
	_process_animation()
	
	if not is_multiplayer_authority():
		return
	
	state_component.calculate(self)

func _physics_process(delta):
	if not is_multiplayer_authority():
		return
	
	if not state_component.is_dead:
		control_component.control(delta)
		velocity_component.move(self)

func _process_animation():
	if linear_velocity != Vector2.ZERO:
		animation["parameters/Walking/conditions/walk"] = true
		animation["parameters/Walking/conditions/idle"] = false
	else:
		animation["parameters/Walking/conditions/walk"] = false
		animation["parameters/Walking/conditions/idle"] = true
	
	if velocity_component.is_crawl or state_component.in_critical or state_component.is_dead:
		animation["parameters/Crawling/conditions/crawl"] = true
		animation["parameters/Crawling/conditions/stand"] = false
	else:
		animation["parameters/Crawling/conditions/crawl"] = false
		animation["parameters/Crawling/conditions/stand"] = true
	
	if state_component.in_critical or state_component.is_dead:
		fov.close_eyes()
	else:
		fov.open_eyes()
	
	parts_component.update_parts_direction(velocity_component.direction)

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

func is_dead():
	return state_component.is_dead

func in_critical():
	return state_component.in_critical

func get_leading_hand():
	return parts_component.leading_hand

func get_selected_hand():
	return parts_component.selected_arm

func get_hand(tag : PartsComponent.Tag) -> Hand:
	var hand = parts_component.get_part(tag)
	if hand is Hand:
		return hand
	return null

@rpc("any_peer", "call_local")
func equip(item : NodePath, slot):
	parts_component.set_slot(slot, item)

@warning_ignore("unused_parameter")
func attach_part(part):
	# attach missing part here
	pass

@warning_ignore("unused_parameter")
func detache_part(part):
	# detache body part here
	pass

func get_part(part_tag) -> BodyPart:
	return parts_component.get_part(part_tag)

func get_parts():
	return parts_component.get_parts()

@rpc("any_peer", "call_local")
func do_brute_damage(value : float, target = PartsComponent.Tag.MISSING):
	parts_component.do_brute_damage(value, target)

@rpc("any_peer", "call_local")
func do_burn_damage(value : float, target = PartsComponent.Tag.MISSING):
	parts_component.do_burn_damage(value, target)

@rpc("any_peer", "call_local")
func do_toxin_damage(value : float):
	toxin_damage.damage(value)

@rpc("any_peer", "call_local")
func do_suff_damage(value : float):
	suff_damage.damage(value)

func get_brute_damage():
	return parts_component.get_brute_damage()

func get_burn_damage():
	return parts_component.get_burn_damage()

func get_toxin_damage():
	return toxin_damage.damage_value

func get_suff_damage():
	return suff_damage.damage_value

func get_total_damage():
	return get_brute_damage() + get_burn_damage() + get_toxin_damage() + get_suff_damage()

func get_slot(part_tag) -> SlotComponent:
	return parts_component.get_slot(part_tag)

@rpc("any_peer", "call_local")
func set_slot(part_tag, value):
	parts_component.set_slot(part_tag, value)

func is_slot_empty(part_tag) -> bool:
	return parts_component.get_slot(part_tag).get_item() == null

func get_state():
	return state_component

func throw_item(direction : Vector2, target : PartsComponent.Tag = PartsComponent.Tag.MISSING):
	var hand : Hand = get_hand(get_selected_hand())
	
	if not hand:
		return
	
	var item : Item = hand.get_hand_item()
	
	if not item:
		return
	
	hand.drop_item.rpc()
	item.throw.rpc(direction.normalized() * velocity_component.throw_force)
