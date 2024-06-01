extends Node2D
class_name BodyPart

@export var brute_damage : DamageComponent
@export var burn_damage : DamageComponent

@export var health : HealthComponent
var has_bone : bool = false
var is_bone_broken : bool = false

var size : int
var is_covered : bool = false
@export var slot_component : SlotComponent
@export var sprite_component : BodyPartSpriteComponent
@export var entrails_component : EntrailsComponent

@export var tag : PartsComponent.Tag = PartsComponent.Tag.MISSING
@export var connections : Array[PartsComponent.Tag]

func _process(_delta):
	if material is ShaderMaterial:
		material.set_shader_parameter("damage", health.get_value())

func update_direction(_direction):
	sprite_component.update_direction(_direction)
	slot_component.update_direction(_direction)

func get_health():
	return health.get_value()

func get_brute_damage():
	return brute_damage.damage_value

func do_brute_damage(value : float):
	brute_damage.damage(value)

func heal_brute_damage(value : float):
	brute_damage.heal(value)

func get_burn_damage():
	return burn_damage.damage_value

func do_burn_damage(value : float):
	burn_damage.damage(value)

func heal_burn_damage(value : float):
	burn_damage.heal(value)

func has_entrails():
	return entrails_component != null

func has_slot():
	return slot_component != null

func get_slot():
	return slot_component

func set_slot(value):
	slot_component.set_slot(value)

func inject(organ):
	entrails_component.inject(organ)

func eject(organ : EntrailsComponent.OrganTags):
	return entrails_component.eject(organ)

func get_organs():
	return entrails_component.get_organs()

func has_organ(_tag : EntrailsComponent.OrganTags):
	return entrails_component.has_organ(_tag)
