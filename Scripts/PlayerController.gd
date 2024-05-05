extends Node2D

# multiplayer configuration
var username : String

@export var speed : float = 3000.0
@export var push_force : float = 100.0
@export var power : float = 30.0

@export var in_body_fov : PointLight2D
@export var ghost_fov : DirectionalLight2D
@export var camera : Node2D

var intent : int = 0 # 0 - help, 1 - hurt, 2 - resist, 3 - grab

var is_ghost : bool = true
@export var pickup_zone : Area2D
@export var body : CharacterBody2D
var brain : Node2D # for future


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.interact.connect(interact_with)
	Signals.intent_change.connect(change_intent)

func _physics_process(delta):
	if not body:
		return
	
	body.velocity = Vector2.ZERO
	
	var result_speed : float = speed
	var result_force : float = push_force
	
	if Input.is_action_pressed("run"):
		result_speed *= 2.0
		result_force *= 1.5
	
	if Input.is_action_pressed("up"):
		body.velocity.y = -(delta * result_speed)
	if Input.is_action_pressed("down"):
		body.velocity.y = delta * result_speed
	if Input.is_action_pressed("left"):
		body.velocity.x = -(delta * result_speed)
	if Input.is_action_pressed("right"):
		body.velocity.x = delta * result_speed
		
	if body.move_and_slide():
		for i in body.get_slide_collision_count():
			var collision = body.get_slide_collision(i)
			if collision.get_collider() is RigidBody2D:
				collision.get_collider().apply_force(collision.get_normal() * -result_force)
	
	camera.transform = body.transform

func interact_with(body):
	if is_ghost:
		if intent == 3:
			in_body_fov.show()
			ghost_fov.hide()
			self.body.free()
			self.body = body
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
