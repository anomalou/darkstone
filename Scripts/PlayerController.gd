extends CharacterBody2D

@export var speed : float = 3000.0
@export var push_force : float = 100.0
@export var power : float = 30.0

@export var in_body_fov : Node2D

var intent : int = 0 # 0 - help, 1 - hurt, 2 - resist, 3 - grab

var is_ghost : bool = true
var pickup_zone : Area2D
var body : Node2D
var brain : Node2D # for future


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.interact.connect(interact_with)
	Signals.intent_change.connect(change_intent)
	
	pickup_zone = find_child("DetectionArea")

func _physics_process(delta):
	velocity = Vector2.ZERO
	
	var result_speed : float = speed
	var reslut_force : float = push_force
	
	if Input.is_action_pressed("run"):
		result_speed *= 2.0
		reslut_force *= 1.5
	
	if Input.is_action_pressed("up"):
		velocity.y = -(delta * result_speed)
	if Input.is_action_pressed("down"):
		velocity.y = delta * result_speed
	if Input.is_action_pressed("left"):
		velocity.x = -(delta * result_speed)
	if Input.is_action_pressed("right"):
		velocity.x = delta * result_speed
		
	if move_and_slide():
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider() is RigidBody2D:
				collision.get_collider().apply_force(collision.get_normal() * -reslut_force)

func _process(delta):
	pass

func interact_with(body):
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
