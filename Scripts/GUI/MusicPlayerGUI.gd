extends Window
class_name MusicPlayerGUI

@export var music_item_scene : PackedScene

@onready var list : VBoxContainer = $Player/Panel/Scroll/List
@onready var current_play : Label = $Player/Label

@onready var player : MusicPlayer = get_node(Constants.music_player)
@onready var volume_slider : HSlider = $Player/Volume

func _ready():
	hide()
	build()

func _process(_delta):
	current_play.text = player.current_song_name

func _on_play_pressed():
	player.play_current.rpc()

func _on_stop_pressed():
	player.stop_music.rpc()

func _on_close_requested():
	hide()

func build():
	for music in player.music.keys():
		var item : MusicSelector = music_item_scene.instantiate()
		item.music_name = music
		item.music_id = player.music.keys().find(music)
		
		list.add_child(item)


func _on_music_pressed():
	show()

func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_slider.value)
