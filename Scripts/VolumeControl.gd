extends Node

@export_group("Volume Control Options")
@export var volume_type: String = "TestVolume"
@export var audio_bus_name: String = "main"

@onready var label: Label = $VolumeLabel
var bus_index: int

# Called when the node enters the scene tree for the first time.
func _ready():
	bus_index = AudioServer.get_bus_index(audio_bus_name)
	label.text = "%s Volume" % volume_type

func _on_volume_slider_value_changed(value: float):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
