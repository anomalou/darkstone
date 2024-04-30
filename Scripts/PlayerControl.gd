extends CharacterBody2D

@export var speed : float = 3000.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	
	var result_speed : float = speed
	
	if Input.is_action_pressed("run"):
		result_speed *= 2.0
	
	if Input.is_action_pressed("up"):
		velocity.y = -(delta * result_speed)
	if Input.is_action_pressed("down"):
		velocity.y = delta * result_speed
	if Input.is_action_pressed("left"):
		velocity.x = -(delta * result_speed)
	if Input.is_action_pressed("right"):
		velocity.x = delta * result_speed
		
	move_and_slide()
	pass
