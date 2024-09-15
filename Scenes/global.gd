extends Node2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_audio_stream_player_2d_finished() -> void:
	audio_stream_player_2d.play()
