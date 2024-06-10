extends Node
class_name StateComponent

var body : Body
@export var blood_component : BloodComponent

var is_dead : bool = false
var in_critical : bool = false
var is_blind : bool = false

@export var damage_limit : float = 800.0

func calculate(_body):
	self.body = _body
	
	head_process()
	upper_body_process()
	groin_process()
	
	blood_process()
	damage_process()
	critical_process()

func blood_process():
	if is_dead:
		return
	
	if blood_component.get_level() < (0.7 * blood_component.get_max_level()):
		if randf() > 0.6:
			body.do_suff_damage(randf() * (3.0 - (blood_component.get_level() / blood_component.get_max_level())))
	if blood_component.get_level() < (0.2 * blood_component.get_max_level()):
		body.do_suff_damage(randf() * 1.5)

func damage_process():
	if is_dead:
		return
	
	var total = body.get_total_damage()
	
	if total >= damage_limit:
		in_critical = true
	else:
		in_critical = false

func critical_process():
	if is_dead or not in_critical:
		return
	
	if randf() > 0.7: # try die in crit
		is_dead = true

func head_process():
	var head = body.get_part(PartsComponent.Tag.HEAD)
	
	if not head:
		is_dead = true
		return
	
	if head.get_health() < 0.1:
		is_dead = true
		return
	
	if not head.has_organ(EntrailsComponent.OrganTags.BRAIN):
		is_dead = true
		return
	
	if not head.has_organ(EntrailsComponent.OrganTags.EYES):
		is_blind = true
	
	is_dead = false

func upper_body_process():
	if is_dead:
		return
	
	var upper_body = body.get_part(PartsComponent.Tag.UPPER_BODY)
	
	if not upper_body.has_organ(EntrailsComponent.OrganTags.HEART) or not upper_body.has_organ(EntrailsComponent.OrganTags.LUNGS):
		body.do_suff_damage(randf() * 5.0)
	
	is_dead = false

func groin_process():
	if is_dead:
		return
	
	var groin = body.get_part(PartsComponent.Tag.GROIN)
	
	if not groin.has_organ(EntrailsComponent.OrganTags.LIVER):
		body.do_toxin_damage(randf() * 2.0)
	
	is_dead = false
