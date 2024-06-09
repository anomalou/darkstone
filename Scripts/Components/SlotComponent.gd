extends RemoteTransform2D
class_name SlotComponent

var item : Item

@export var z_level : int = 0
@export var mirror_item : bool = false

func _find_item():
	if remote_path.is_empty():
		return
	
	if not item:
		item = get_node(remote_path)
	
	return item

func update_direction(_direction):
	var _item = _find_item()
	if _item:
		_item.update_direction(_direction, mirror_item)

@rpc("any_peer", "call_local")
func set_slot(path : NodePath):
	if item:
		return
	
	var _item : Item = get_node(path)
	if not _item:
		return
	
	_item.set_multiplayer_authority(get_multiplayer_authority())
	
	_item.z_index = z_level
	_item.z_as_relative = false
	
	item = null
	
	remote_path = _item.get_path()

func is_empty():
	return remote_path.is_empty()

func get_item():
	return _find_item()

func get_item_path():
	if remote_path.is_empty():
		return false
	return remote_path

@rpc("any_peer", "call_local")
func remove_item():
	if remote_path.is_empty():
		return
	
	item = get_item()
	
	if not item:
		return
	
	item.z_index = 0
	item.z_as_relative = true
	
	remote_path = NodePath()
	item = null
