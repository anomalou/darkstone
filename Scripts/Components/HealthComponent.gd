extends Node
class_name HealthComponent

var health : float = 1.0

func get_value():
	return health

func damage(value : float):
	health = max(0, health - value)

func heal(value : float):
	health = min(1.0, health + value)
