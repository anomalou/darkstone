extends Action
class_name PickUpAction

@export var item : Node2D

func do(player, item = null): # data is body nodepath that shound pick up item
	var _body : Body = get_node(player)
	
	if _body.is_slot_empty(_body.get_selected_hand()):
		_body.equip.rpc(self.item.get_path(), _body.get_selected_hand())
		return true
	return false
