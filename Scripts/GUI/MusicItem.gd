extends Button
class_name MusicSelector

@onready var player : MusicPlayer = get_node(Constants.music_player)

var music_name : String
var music_id : int

func _enter_tree():
	text = music_name

func _on_pressed():
	player.select_music_by_id.rpc(music_id)
