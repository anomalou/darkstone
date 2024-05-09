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

# rewrite to signal
func raise_up():
	var player = Multiplayer.get_player()
	if not player:
		return
	
	if player.is_ghost:
		return
	
	var player_body : Body = player.get_body()
	if not player_body:
		return
	if player_body:
		if player_body.set_slot("left_arm", id):
			Saylog.add.rpc(ItemData.get_pickup_message(id))
			queue_free()
			
func examine():
	Saylog.add(ItemData.get_description(id))

func _on_input_event(_viewport, event : InputEvent, _shape_idx):
	if event.is_action_pressed("examine"):
		examine()
	elif event.is_action_pressed("left_click"):
		raise_up()
