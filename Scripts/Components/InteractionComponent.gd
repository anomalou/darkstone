extends Area2D
class_name InteractionComponent

@export var help_action : Action
@export var hurt_action : Action
@export var resist_action : Action
@export var grab_action : Action

@export var examine_action : Action

func do_action(intent):
	match intent:
		0:
			if help_action:
				help_action.do()
		1:
			if hurt_action:
				hurt_action.do()
		2:
			if resist_action:
				resist_action.do()
		3:
			if grab_action:
				grab_action.do()

func examine():
	if examine_action:
		examine_action.do()
