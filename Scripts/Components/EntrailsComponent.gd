extends Node
class_name EntrailsComponent

enum OrganTags {
	BRAIN,
	EYES,
	EARS,
	HEART,
	LUNGS,
	LIVER,
	APPENDIX
}

@export var required_organs : Array[OrganTags]
@export var allowed_organs : Array[OrganTags]

func inject(organ : OrganComponent):
	if organ.type in allowed_organs:
		add_child(organ)

func eject(organ_tag : OrganTags):
	for organ in get_children():
		if organ is OrganComponent:
			remove_child(organ)

func get_organs():
	var organs : Array
	for organ in get_children():
		if organ is OrganComponent:
			organs.append(organ)
	return organs

func has_organ(tag : OrganTags):
	for organ in get_children():
		if organ is OrganComponent:
			if organ.type == tag:
				return true
	return false

func damage_organ(type : OrganTags, value : float):
	for organ in get_children():
		if organ is OrganComponent:
			if organ.type == type:
				organ.damage(value)
				return

func heal_organ(type : OrganTags, value : float):
	for organ in get_children():
		if organ is OrganComponent:
			if organ.type == type:
				organ.heal(value)
				return
