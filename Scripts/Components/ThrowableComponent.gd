extends Area2D
class_name ThrowableComponent

@export var collide_action : Action

var in_air : bool = false

func _on_body_entered(body):
	if in_air:
		collide_action.do(body, null)
