extends Node

@onready var musak_player: AudioStreamPlayer = $MusakPlayer
@onready var beep_player: AudioStreamPlayer = $BeepPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_beep_button_pressed():
	beep_player.play()

func _on_music_button_pressed():
	musak_player.play()

func _on_stop_music_button_pressed():
	musak_player.stop()
