extends Control

var multiplayer_config : Window

func _ready():
	multiplayer_config = get_node("./MultiplayerConfig")

func _on_multiplayer_pressed():
	multiplayer_config.show()
