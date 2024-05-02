extends RigidBody2D

@export var id : String

var accumlated_force : Vector2 = Vector2.ZERO

func _ready():
	gravity_scale = 0

func _process(_delta):
	if id != null:
		var texture_name = ItemData.get_ground_texture_name(id)
		var tex = load("res://Sprites/Ground/" + texture_name + ".tres")
		var sprite : Sprite2D = get_child(1)
		sprite.texture = tex

func raise_up():
	Inventory.set_left_hand(id)
	Saylog.add(ItemData.get_pickup_message(id))
	queue_free()

func _on_input_event(viewport, event : InputEvent, shape_idx):
	if event.is_action_pressed("left_click"):
		raise_up()
