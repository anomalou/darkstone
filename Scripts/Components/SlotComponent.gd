extends Node
class_name SlotComponent

var item_path : NodePath
var item : Item

func _find_item():
	if not item_path:
		return
	
	if not item:
		item = get_node(item_path)
	
	return item

func update_direction(_direction):
	var _item = _find_item()
	if _item:
		_item.update_direction(_direction)

func set_slot(path : NodePath):
	if item:
		return
	
	var _item : Item = get_node(path)
	if not _item:
		return false
	
	item = null
	var old_parent = _item.get_parent()
	if old_parent:
		old_parent.remove_child(_item)
	
	add_child(_item)
	_item.set_equiped()
	
	item_path = _item.get_path()
	
	return true

func get_item():
	return _find_item()
