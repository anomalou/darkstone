extends Area2D
class_name InteractionComponent

@export var help_action : Action
@export var hurt_action : Action
@export var resist_action : Action
@export var grab_action : Action

@export var examine_action : Action

func do_action(player, intent):
	var action : Action = null
	
	match intent:
		0:
			action = help_action
		1:
			action = hurt_action
		2:
			action = resist_action
		3:
			action = grab_action
	
	return Utils.option(action, func(a): return a.do(player, null));

func examine(player):
	return Utils.option(examine_action, func(a): return a.do(player));
