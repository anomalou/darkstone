extends Node
class_name VelocityComponent

var _velocity : Vector2

@export var walk_speed : float = 3000.0
@export var run_mod : float = 1.5
@export var crawl_mod : float = 0.5 

@export var force : float = 100.0

var is_run : bool
var is_crawl : bool

func accelerate_to(direction : Vector2):
	var speed : float = walk_speed
	if is_run:
		speed = walk_speed * run_mod
	if is_crawl:
		speed = walk_speed * crawl_mod
	
	_velocity = _velocity.lerp(direction * speed, 1)

func move(body : CharacterBody2D):
	body.velocity = _velocity
	
	var _force : float = force
	if is_run:
		_force = force * run_mod
	
	if body.move_and_slide():
		for i in body.get_slide_collision_count():
			var collision = body.get_slide_collision(i)
			if collision.get_collider() is Item:
				collision.get_collider().apply_force_rpc.rpc(collision.get_normal() * -_force)
	
	accelerate_to(Vector2.ZERO)
