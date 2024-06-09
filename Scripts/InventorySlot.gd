extends TextureRect

@export var slot_tag : PartsComponent.Tag
@export var accessory_slot : bool

@onready var server_info : ServerInfo = get_node(Constants.server_info)
@onready var sprite : TextureRect = $Sprite

func _process(_delta):
	if not server_info.is_game_started:
		return
	
	var player : Player = Multiplayer.get_player()
	var body : Body = player.get_body()
	
	var slot : SlotComponent = null
	if not accessory_slot:
		slot = Utils.option(body, func(b): return b.get_slot(slot_tag), func(): return null)
	else:
		print_debug("Not implemented")
	
	var item = Utils.option(slot, func(s): return s.get_item(), func(): return null)
	sprite.texture = Utils.option(item, func(i): return i.get_sprite(), func(): return null)


func _on_gui_input(event : InputEvent):
	if event.is_action_pressed("primary"):
		var player : Player = Multiplayer.get_player()
		var body : Body = player.get_body()
		var slot : SlotComponent = null
		if not accessory_slot:
			slot = Utils.option(body, func(b): return b.get_slot(slot_tag), func(): return null)
		else:
			print_debug("Not implemented")
		
		
		var hand : Hand = Utils.option(body, func(b): return b.get_hand(
				Utils.option(body, func(b): return b.get_selected_hand(), func(): return PartsComponent.Tag.MISSING)
			))
		
		if not hand:
			return 
		
		var hand_slot : SlotComponent = hand.get_hand_slot()
		
		var equip = true
		var item_path = Utils.move_item(hand_slot, slot)
		
		if not item_path: # slot is allready contain item
			if not hand_slot.get_item_path():
				if not slot.get_item_path():
					return
				
				item_path = Utils.move_item(slot, hand_slot)
				if not item_path:
					return
				equip = false
		
		var item : Item = get_node(item_path)
		
		if equip:
			item.set_equiped()
		else:
			item.set_unequiped()
		
