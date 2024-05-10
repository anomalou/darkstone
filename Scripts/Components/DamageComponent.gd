extends Node
class_name DamageComponent

var damage_value : float

func damage(value : float):
	damage_value = max(0, damage_value + value)

func heal(value : float):
	damage(-value)
