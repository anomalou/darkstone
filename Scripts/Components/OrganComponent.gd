extends Node
class_name OrganComponent

@export var type : EntrailsComponent.OrganTags

@export var name_component : NameComponent
@export var health_component : HealthComponent

func get_organ_name():
	return name_component.get_value()

func damage(value):
	health_component.damage(value)

func heal(value):
	health_component.heal(value)
