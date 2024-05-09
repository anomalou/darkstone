extends Node2D
class_name Player

# multiplayer configuration

@export var speed : float = 3000.0
@export var push_force : float = 100.0
@export var power : float = 30.0

@onready var in_body_fov : PointLight2D = $Camera/BodyFOV
@onready var ghost_fov : DirectionalLight2D = $Camera/GhostFOV
@onready var camera : Node2D = $Camera

var intent : int = 0 # 0 - help, 1 - hurt, 2 - resist, 3 - grab

var is_ghost : bool = true

@export var pickup_zone : Area2D
@export var body : NodePath
@onready var ghost : Node2D = $Ghost
var brain : Node2D # for future

var game_control : GameControl
@onready var animation : AnimationTree = $AnimationTree

func _enter_tree():
	set_multiplayer_authority(name.split("_")[0].to_int())

func _ready():
	Signals.interact.connect(interact_with)
	Signals.intent_change.connect(change_intent)
	
	game_control = $/root/World/GUI/GameControl
	
	animation.active = true
	
	if not is_multiplayer_authority():
		camera.queue_free() # free not your camera
		animation.active = false

func _process(delta):
	if is_multiplayer_authority():
		_process_animation()

func _process_animation():
	var _body = get_body()
	if not _body:
		return
	
	animation["parameters/conditions/reduce"] = _body.in_critical or _body.in_coma or _body.in_sleep
	animation["parameters/conditions/restore"] = not _body.in_critical and not _body.in_coma and not _body.in_sleep

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
	
	var _body : CharacterBody2D
	
	if is_ghost:
		_body = ghost
	else:
		_body = get_node(self.body)
	
	if not _body:
		return
	
	_body.velocity = Vector2.ZERO
	
	var result_speed : float = speed
	var result_force : float = push_force
	
	if Input.is_action_pressed("run"):
		result_speed *= 2.0
		result_force *= 1.5
	
	_body.velocity = Input.get_vector("left", "right", "up", "down") * delta * result_speed
	
	if _body.move_and_slide():
		for i in _body.get_slide_collision_count():
			var collision = _body.get_slide_collision(i)
			if collision.get_collider() is RigidBody2D:
				collision.get_collider().apply_force(collision.get_normal() * -result_force)
	
	if camera != null:
		camera.transform = _body.transform

func interact_with(_body : Body):
	if not is_multiplayer_authority():
		return
	
	if is_ghost:
		if intent == 3:
			in_body_fov.show()
			ghost_fov.hide()
			_destroy_body()
			self.body = _body.get_path()
			is_ghost = false
		return

	match intent:
		0:
			game_control.body_status.show_info(_body)
		1:
			_body.do_brute_damage.rpc(randf() * power)
		2:
			_body.set_critical.rpc(true)
			print("shove")
		3:
			_body.set_critical.rpc(false)
			print("grab")

func change_intent(intent_id):
	intent = intent_id
	print(intent)
