extends Node
class_name ControlComponent

@export var velocity_component : VelocityComponent
@export var parts_component : PartsComponent 

func _physics_process(delta):
	if not is_multiplayer_authority():
		return
	
	if Input.is_action_pressed("swap_hand"):
		if parts_component.selected_arm == PartsComponent.Tag.RIGHT_ARM:
			parts_component.selected_arm = PartsComponent.Tag.LEFT_ARM
		else:
			parts_component.selected_arm = PartsComponent.Tag.RIGHT_ARM
	
	if Input.is_action_pressed("run"):
		velocity_component.is_run = true
	else:
		velocity_component.is_run = false
	
	if Input.is_action_just_pressed("crawl"):
		velocity_component.is_crawl = not velocity_component.is_crawl
	
	var direction = Input.get_vector("left", "right", "up", "down") * delta
	
	velocity_component.accelerate_to(direction)
	
