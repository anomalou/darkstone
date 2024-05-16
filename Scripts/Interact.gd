extends Node2D
class_name InteractMarker

@onready var player : Player = Multiplayer.get_player()
@onready var discovery_ray : RayCast2D = $DiscoveryRay
@onready var range_ray : RayCast2D = $RangeRay
var nodes : Array
	
func discover():
	range_ray.target_position = to_local(player.get_body().global_position)
	
	range_ray.force_raycast_update()
	
	if range_ray.is_colliding():
		if range_ray.get_collider() != player.get_body():
			return
	
	discovery_ray.force_raycast_update()
	
	if discovery_ray.is_colliding():
		player.interact_with(discovery_ray.get_collider())
	
	queue_free()
