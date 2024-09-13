extends Node2D

@onready var rich_text_label: RichTextLabel = $Control/RichTextLabel
@onready var timer: Timer = $Control/Timer
var time_elapsed: int = 0
signal one_second

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = 1.0
	timer.start()

func update_label() -> void:
	var min: int = int(time_elapsed / 60.0)
	var sec: int = time_elapsed - min * 60
	rich_text_label.text = '%02d:%02d' % [min, sec]

func _on_timer_timeout() -> void:
	time_elapsed += 1
	update_label()
	one_second.emit()
