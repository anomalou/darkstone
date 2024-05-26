extends Action
class_name PickUpAction

@export var item : Node2D

func do(data = null): # data is body nodepath that shound pick up item
	var body : Body = get_node(data)
	body.equip.rpc(item.get_path(), body.get_selected_hand())
