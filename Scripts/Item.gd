extends Sprite2D

@export var id : String

func _process(_delta):
	if id != null:
		var texture_name = ItemData.get_ground_texture_name(id)
		var tex = load("res://Sprites/Ground/" + texture_name + ".tres")
		texture = tex

func _input(event):
	if event.is_action_pressed("left_click"):
		if event is InputEventMouseButton:
			if get_rect().has_point(get_local_mouse_position()):
				raise_up()

func raise_up():
	Inventory.set_left_hand(id)
	Saylog.add(ItemData.get_pickup_message(id))
