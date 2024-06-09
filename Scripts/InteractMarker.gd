extends Node2D
class_name InteractMarker

@onready var player : Player = Multiplayer.get_player()
@onready var discovery_ray : RayCast2D = $DiscoveryRay
@onready var range_ray : RayCast2D = $RangeRay
var nodes : Array

var range_to_player : float

func get_collider():
	range_ray.target_position = to_local(player.get_body().global_position)
	
	range_ray.force_raycast_update()
	
	range_to_player = range_ray.target_position.length()
	
	if range_ray.is_colliding():
		return
	
	discovery_ray.force_raycast_update()
	
	if discovery_ray.is_colliding():
		return discovery_ray.get_collider()
	return

func get_object() -> InteractionComponent:
	var col = get_collider()
	
	queue_free()
	
	return col
