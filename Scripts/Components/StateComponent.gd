extends Node
class_name StateComponent

var body : Body
@export var blood_component : BloodComponent

var is_dead : bool = false
var in_critical : bool = false

@export var damage_limit : float = 800.0

func calculate(_body):
	self.body = _body
	
	var alive = is_head_alive()
	alive = is_upper_body_alive(alive)
	alive = is_groin_alive(alive)
	alive = blood_process(alive)
	
	damage_process(alive)
	
	alive = critical_process(alive)
	
	is_dead = not alive

func blood_process(alive):
	if not alive:
		return false
	
	if blood_component.get_level() < (0.7 * blood_component.get_max_level()):
		if randf() > 0.6:
			body.do_suff_damage(randf() * (3.0 - (blood_component.get_level() / blood_component.get_max_level())))
	if blood_component.get_level() < (0.2 * blood_component.get_max_level()):
		body.do_suff_damage(randf() * 1.5)
	
	return true

func damage_process(alive):
	if not alive:
		return
	
	var total = body.get_total_damage()
	
	if body.get_total_damage() >= damage_limit:
		in_critical = true
	else:
		in_critical = false

func critical_process(alive):
	if not in_critical or not alive:
		return true
	
	if randf() > 0.7: # try die in crit
		return false
	return true

func is_head_alive():
	var head = body.get_part(PartsComponent.Part.HEAD)
	
	if not head:
		return false
	
	if head.get_health() < 0.1:
		return false
	
	if not head.has_organ(EntrailsComponent.OrganTags.BRAIN):
		return false
	
	return true

func is_upper_body_alive(is_alive):
	if not is_alive:
		return false
	
	var upper_body = body.get_part(PartsComponent.Part.UPPER_BODY)
	
	if not upper_body.has_organ(EntrailsComponent.OrganTags.HEART) or not upper_body.has_organ(EntrailsComponent.OrganTags.LUNGS):
		body.do_suff_damage(randf() * 5.0)
	
	return true

func is_groin_alive(is_alive):
	if not is_alive:
		return false
	
	var groin = body.get_part(PartsComponent.Part.GROIN)
	
	if not groin.has_organ(EntrailsComponent.OrganTags.LIVER):
		body.do_toxin_damage(randf() * 2.0)
	
	return true
