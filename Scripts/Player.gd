extends Node2D
class_name Player

# multiplayer configuration

var in_body_fov : PointLight2D
var camera : Node2D
@onready var interaction : Node2D = $Interaction
@onready var ghost_fov : DirectionalLight2D = $Interaction/GhostFOV


var intent : int = 0 # 0 - help, 1 - hurt, 2 - resist, 3 - grab

@export var is_ghost : bool = true

@export var body : NodePath
@onready var ghost : Node2D = $Ghost
var brain : Node2D # for future

var game_control : GameControl
@onready var animation : AnimationTree = $AnimationTree

@export var direction_ray : RayCast2D
@export var pick_up_zone : Area2D

var pick_up_list : Array

func _enter_tree():
	if not GameState.debug:
		set_multiplayer_authority(name.split("_")[0].to_int())

func _ready():
	if is_multiplayer_authority():
		in_body_fov = get_node(Constants.fov)
		camera = get_node(Constants.camera)
	
	Signals.intent_change.connect(change_intent)
	
	game_control = GameState.game_control
	
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
		in_body_fov.show()
		ghost_fov.hide()
	else:
		ghost.show()
		in_body_fov.hide()
		ghost_fov.show()
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

func interact():
	var mouse_pos = get_global_mouse_position()
	var len = mouse_pos - get_body().global_position
	len = len.length()
	direction_ray.target_position = get_global_mouse_position() - get_body().position
	
	if pick_up_zone.has_overlapping_bodies():
		for _body in pick_up_zone.get_overlapping_bodies():
			pass
	
	direction_ray.force_raycast_update()
	
	if direction_ray.is_colliding():
		var col = direction_ray.get_collider()
		if intent == 0:
			if col is Body:
				game_control.body_status.show_info(col)

func pick_up_menu():
	if pick_up_zone.has_overlapping_bodies():
		GameState.pick_up_list.build_menu(pick_up_zone.get_overlapping_bodies())
		GameState.pick_up_list.open_interact_menu()

func change_intent(intent_id):
	intent = intent_id
	#print(intent)

func _on_pick_up_zone_body_entered(_body):
	pick_up_list.append(_body)

func _on_pick_up_zone_body_exited(_body):
	pick_up_list.erase(_body)

func _on_pick_up_zone_input_event(viewport, event : InputEvent, shape_idx):
	if event.is_action_pressed("right_click"):
		pick_up_menu()

func _input(event):
	if not is_multiplayer_authority():
		return
	
	if event.is_action_pressed("left_click"):
		interact()
