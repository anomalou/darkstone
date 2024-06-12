extends Node2D
class_name Player

enum Intent {
	HELP,
	HURT,
	RESIST,
	GRAB
}

# multiplayer configuration

var in_body_fov : PointLight2D
var camera : Node2D

var throw_mode = false
var intent : Intent = Intent.HELP
@export var interact_range : float = 54.0 # 1.5 tile
@export var throw_force : float = 200.0

@onready var interact_marker : PackedScene = preload("res://Scenes/interact.tscn")
@export var is_ghost : bool = false

@export var body : NodePath
var _body_cache : Body
@onready var ghost : Node2D = $Ghost
var brain : Node2D # for future

@onready var game_control : GameControl = GUIManager.game_overlay

@onready var network : Node2D = get_node(Constants.network)

var pick_up_list : Array

func _enter_tree():
	set_multiplayer_authority(name.split("_")[0].to_int())

func _ready():
	if is_multiplayer_authority():
		in_body_fov = get_node(Constants.fov)
		camera = get_node(Constants.camera)
	
	Signals.intent_change.connect(change_intent)

func _process(_delta):
	if is_multiplayer_authority():
		_process_animation()

func _process_animation():
	var _body = get_body()
	if not _body:
		return

func get_body() -> Body:
	if body:
		if not _body_cache:
			_body_cache = get_node(body)
		return _body_cache
	else:
		return null

@rpc("any_peer", "call_local")
func set_body(path):
	body = path

@rpc("any_peer", "call_local")
func set_alive(value):
	if value:
		ghost.hide()
	else:
		ghost.show()
	is_ghost = not value

func _destroy_body():
	var _body = get_body()
	if _body:
		_body.queue_free()

func _physics_process(_delta):
	if not is_multiplayer_authority():
		return
	
	var _body : Body
	
	if is_ghost:
		_body = ghost
	else:
		_body = get_node(self.body)
	
	if not _body:
		return
	
	if camera != null:
		camera.transform = _body.transform
	
	if in_body_fov:
		in_body_fov.transform = _body.transform

func create_marker():
	var mouse_pos = get_global_mouse_position()
	
	var marker : InteractMarker = interact_marker.instantiate()
	marker.position = mouse_pos
	network.add_child(marker)
	return marker

func change_intent(intent_id):
	intent = intent_id

func _input(event):
	if not is_multiplayer_authority():
		return
	
	if throw_mode:
		if event.is_action_pressed("primary"):
			throw_item(get_global_mouse_position())
	
	var object = create_marker().get_object()
	
	if event.is_action_pressed("examine"):
		Utils.option(object, func(o): o.examine(body), func(): print("Nothing to examine"))
	elif event.is_action_pressed("primary"):
		if not Utils.option(object, func(o): o.do_action(body, intent)):
			pass

#TODO test throw move in body
func throw_item(direction):
	var _body : Body = get_body()
	
	if not _body:
		return
	
	var hand : Hand = _body.get_hand(_body.get_selected_hand())
	
	if not hand:
		return
	
	var item : Item = hand.get_hand_item()
	
	if not item:
		return
	
	hand.drop_item.rpc()
	item.throw.rpc(Vector2(direction - _body.global_position).normalized() * throw_force)
