extends Node2D
class_name Player

# multiplayer configuration

var in_body_fov : PointLight2D
var camera : Node2D
@onready var interaction : Node2D = $Interaction
@onready var ghost_fov : DirectionalLight2D = $Interaction/GhostFOV

var intent : int = 0 # 0 - help, 1 - hurt, 2 - resist, 3 - grab
@export var interact_range : float = 54.0 # 1.5 tile

@onready var interact_marker : PackedScene = preload("res://Scenes/interact.tscn")
@export var is_ghost : bool = false

@export var body : NodePath
@onready var ghost : Node2D = $Ghost
var brain : Node2D # for future

@onready var game_control : GameControl = GUIManager.game_overlay
@onready var animation : AnimationTree = $AnimationTree

@onready var network : Node2D = get_node(Constants.network)

var pick_up_list : Array

func _enter_tree():
	set_multiplayer_authority(name.split("_")[0].to_int())

func _ready():
	if is_multiplayer_authority():
		in_body_fov = get_node(Constants.fov)
		camera = get_node(Constants.camera)
	
	Signals.intent_change.connect(change_intent)
	
	animation.active = true
	
	if not is_multiplayer_authority():
		animation.active = false

func _process(delta):
	if is_multiplayer_authority():
		_process_animation()

func _process_animation():
	var _body = get_body()
	if not _body:
		return
	
	animation["parameters/conditions/reduce"] = _body.in_critical() or _body.is_dead()
	animation["parameters/conditions/restore"] = not _body.in_critical() and not _body.is_dead()

func get_body() -> Body:
	return get_node(body)

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

func _physics_process(delta):
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
	
	if interaction:
		interaction.transform = _body.transform

func init_interact():
	var mouse_pos = get_global_mouse_position()
	
	var marker : InteractMarker = interact_marker.instantiate()
	marker.position = mouse_pos
	network.add_child(marker)
	return marker

func interact_with(node):
	if node is Body:
		game_control.body_status.show_info(node)

func change_intent(intent_id):
	intent = intent_id

func _input(event):
	if not is_multiplayer_authority():
		return
	
	if event.is_action_pressed("examine"):
		init_interact().examine()
	elif event.is_action_pressed("left_click"):
		init_interact().interact(intent)
