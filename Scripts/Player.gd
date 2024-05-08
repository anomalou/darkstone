extends Node2D
class_name Player

# multiplayer configuration

@export var speed : float = 3000.0
@export var push_force : float = 100.0
@export var power : float = 30.0

@export var in_body_fov : PointLight2D
@export var ghost_fov : DirectionalLight2D
@export var camera : Node2D

var intent : int = 0 # 0 - help, 1 - hurt, 2 - resist, 3 - grab

var is_ghost : bool = true

@export var pickup_zone : Area2D
@export var body : NodePath
@export var ghost : Node2D
var brain : Node2D # for future


func _enter_tree():
	set_multiplayer_authority(name.split("_")[0].to_int())

func _ready():
	Signals.interact.connect(interact_with)
	Signals.intent_change.connect(change_intent)
	
	if not is_multiplayer_authority():
		camera.queue_free() # free not your camera

func _get_body():
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
	var body = _get_body()
	if body:
		body.queue_free()
		

func _physics_process(delta):
	var body : CharacterBody2D
	
	if is_ghost:
		body = ghost
	else:
		body = get_node(self.body)
	
	if not body:
		return
	
	body.velocity = Vector2.ZERO
	
	var result_speed : float = speed
	var result_force : float = push_force
	
	if Input.is_action_pressed("run"):
		result_speed *= 2.0
		result_force *= 1.5
	
	body.velocity = Input.get_vector("left", "right", "up", "down") * delta * result_speed
	
	if body.move_and_slide():
		for i in body.get_slide_collision_count():
			var collision = body.get_slide_collision(i)
			if collision.get_collider() is RigidBody2D:
				collision.get_collider().apply_force(collision.get_normal() * -result_force)
	
	if camera != null:
		camera.transform = body.transform

func interact_with(body):
	
	return # temporary
	
	if is_ghost:
		if intent == 3:
			in_body_fov.show()
			ghost_fov.hide()
			_destroy_body()
			self.body = body.get_path()
			is_ghost = false
		return

	match intent:
		0:
			Signals.show_medinfo(body)
		1:
			body.do_brute_damage(randf() * power, "upper_body")
		2:
			print("shove")
		3:
			print("grab")

func change_intent(intent_id):
	intent = intent_id
	print(intent)
