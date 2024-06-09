extends Node
class_name  MusicPlayer

var current_song_name : String

@export var music : Dictionary
@export var main_menu_music : AudioStream

@onready var streamer : AudioStreamPlayer2D = $Streamer
@onready var server_info : ServerInfo = get_node(Constants.server_info)

func _ready():
	streamer.finished.connect(play_random)
	streamer.stream = main_menu_music
	streamer.play()

@rpc("authority", "call_local")
func select_music(song):
	current_song_name = song

@rpc("authority", "call_local")
func select_music_by_id(id):
	current_song_name = music.keys()[id]

@rpc("authority", "call_local")
func play_music(song):
	if music.has(song):
		current_song_name = song
		streamer.stream = music.get(song)
		streamer.play()

@rpc("authority", "call_local")
func play_current():
	if not server_info.is_local_server:
		await $MultiplayerSynchronizer.synchronized
	if current_song_name:
		play_music(current_song_name)

func play_random():
	var song = music.keys().pick_random()
	play_music(song)

@rpc("authority", "call_local")
func stop_music():
	streamer.stop()
