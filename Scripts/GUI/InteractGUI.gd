extends Control
class_name Interact

@export var item_scene : PackedScene

func open_interact_menu():
	$Menu.position = get_global_mouse_position()
	$Menu.show()

func build_menu(items : Array):
	var list = $Menu/Scroll/List
	
	for child in list.get_children():
		list.remove_child(child)
	
	for item in items:
		var obj : InteractItem = item_scene.instantiate()
		obj.item_name = item.name
		obj.item = item.get_path()
		
		list.add_child(obj)

func _on_menu_close_requested():
	$Menu.hide()
