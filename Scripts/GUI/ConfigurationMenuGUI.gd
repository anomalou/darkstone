extends Control

@onready var multiplayer_config : Window = $MultiplayerConfig

func _on_multiplayer_pressed():
	multiplayer_config.show()
