extends Node
class_name BloodComponent

enum Group {
	O,
	A,
	B,
	AB
}

var blood_level : float
@export var max_blood_level : float
@export var group : Group

func _ready():
	blood_level = max_blood_level
	group = randi_range(0, 3)

func drain(value : float):
	blood_level = max(0, blood_level - value)

func restore(value : float):
	blood_level = min(max_blood_level, blood_level + value)

func get_group_name():
	return Group.keys()[group]
