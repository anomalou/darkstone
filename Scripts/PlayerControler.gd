extends CharacterBody2D

@export var speed : float = 3000.0
@export var push_force : float = 100.0

var pickup_zone : Area2D
var body : Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pickup_zone = find_child("DetectionArea")
	body = find_child("Body")
	

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
