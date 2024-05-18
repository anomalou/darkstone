extends HBoxContainer
class_name InteractItem

var item_name : String
var item : NodePath

func _enter_tree():
	$Label.text = item_name

func _on_label_gui_input(event : InputEvent):
	if event.is_action_pressed("left_click"):
		print(item)
