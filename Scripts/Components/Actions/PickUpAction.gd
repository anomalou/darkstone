extends Action
class_name PickUpAction

@export var item : Node2D

func do(_player, _item = null): # data is body nodepath that shound pick up item
	var _body : Body = get_node(_player)
	
	var hand = _body.get_hand(_body.get_selected_hand())
	
	return Utils.option(hand, func(h): return h.take_item(item.get_path()))
