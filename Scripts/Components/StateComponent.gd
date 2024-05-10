extends Node
class_name StateComponent

@export var body : Body

var is_dead : bool = false
var in_critical : bool = false

@export var damage_limit : float = 800.0

func _process(delta):
	var alive = is_head_alive()
	alive = is_upper_body_alive(alive)
	alive = is_groin_alive(alive)
	
	var total = body.get_total_damage()
	
	if body.get_total_damage() >= damage_limit:
		in_critical = true
	else:
		in_critical = false
	
	alive = critical_process(alive)
	
	is_dead = not alive

func critical_process(alive):
	if not in_critical or not alive:
		return true
	
	if randf() > 0.98: # try die in crit
		return false
	return true

func is_head_alive():
	var head = body.get_part(Body.BodyPartTag.HEAD)
	
	if not head:
		return false
	
	if not head.has_organ(EntrailsComponent.OrganTags.BRAIN):
		return false
	
	return true

func is_upper_body_alive(is_alive):
	if not is_alive:
		return false
	
	var upper_body = body.get_part(Body.BodyPartTag.UPPER_BODY)
	
	if not upper_body.has_organ(EntrailsComponent.OrganTags.HEART) or not upper_body.has_organ(EntrailsComponent.OrganTags.LUNGS):
		body.do_suff_damage(randf() * 10.0)
	
	return true

func is_groin_alive(is_alive):
	if not is_alive:
		return false
	
	var groin = body.get_part(Body.BodyPartTag.GROIN)
	
	if not groin.has_organ(EntrailsComponent.OrganTags.LIVER):
		body.do_toxin_damage(randf() * 5.0)
	
	return true
