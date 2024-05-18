extends Action
class_name ExamineAction

@export var examine : String
@export var substitutes : Array

func do(data = null):
	if substitutes.size() > 0:
		examine = examine.format(substitutes)
	
	Saylog.add(examine)
	