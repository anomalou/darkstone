extends TextureProgressBar
class_name HealthGUI

@onready var server_info : ServerInfo = get_node(Constants.server_info)

func _process(_delta):
	if server_info.is_player_in_game(Multiplayer.get_multiplayer_authority()):
		var player : Player = Multiplayer.get_player()
		var body : Body = player.get_body()
		if not body:
			value = 0.0
			return
		
		var state : StateComponent = body.get_state()
		
		if not state:
			value = 0.0
			return
		
		value = 1.0 - (float(body.get_total_damage()) / state.damage_limit)
