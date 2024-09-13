extends Node2D

@onready var face: AnimatedSprite2D = $Face
@onready var anger: Sprite2D = $Anger
@onready var bar: TextureProgressBar = $Control/TextureProgressBar

@export var max_frustration: int = 100
var current_frustration: int = 0
var face_frames: Array = [0, 1, 2, 3, 4]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	face.pause()
	update_frustration(0)
	
func set_state(frustration: int, face_frame: int, is_anger_visible: bool) -> void:
	current_frustration = frustration
	face.frame = face_frames[face_frame]
	anger.visible = is_anger_visible
	bar.value = current_frustration

func update_frustration(frustration: int) -> void:
	if frustration < 20:
		set_state(frustration, 0, false)
	elif frustration < 40:
		set_state(frustration, 1, false)
	elif frustration < 60:
		set_state(frustration, 2, false)
	elif frustration < 80:
		set_state(frustration, 3, true)
	elif frustration <= 100:
		set_state(frustration, 4, true)
	
