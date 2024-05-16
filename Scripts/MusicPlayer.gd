extends Node
class_name  MusicPlayer

var current_song_name : String

@export var music : Dictionary
@export var main_menu_music : AudioStream

@onready var streamer : AudioStreamPlayer2D = $Streamer

func _ready():
	streamer.finished.connect(play_random)
	streamer.stream = main_menu_music
	streamer.play()

@rpc("any_peer", "call_local")
func play_music(song):
	if music.has(song):
		current_song_name = song
		streamer.stream = music.get(song)
		streamer.play()

func play_current():
	if current_song_name:
		play_music(current_song_name)

func play_random():
	var song = music.keys()[randi() % music.size()]
	play_music.rpc(song)

func stop_music():
	streamer.stop()
