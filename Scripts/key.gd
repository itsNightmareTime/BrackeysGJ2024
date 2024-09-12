extends Node2D

class_name Key # used to create this type of object so methods can be recognized in other scripts

@onready var key: Sprite2D = $Sprite2D
var move_speed: float = -1.0
var key_identity: String
#var key_scale: float = 0.42

func _ready() -> void:
	#scale.x = key_scale
	#scale.y = key_scale
	set_alpha_key_in_queue()

# loads the image and turns it into a texture
func set_key_type(filename : String, identity : String) -> void:
	var image = Image.load_from_file(filename)
	key.texture = ImageTexture.create_from_image(image)
	key_identity = identity

func remove_key() -> void:
	self.queue_free()

# makes key fully visible, used for the active key
func set_alpha_active_key() -> void:
	var color = key.modulate
	color.a = 1.0 
	key.modulate = color
	
# adds opacity to the key, used for the keys in and out of queue
func set_alpha_key_in_queue() -> void:
	var color = key.modulate
	color.a = 0.67
	key.modulate = color
	
# adds opacity to the key, used for the keys in and out of queue
func set_alpha_pressed_key() -> void:
	var color = key.modulate
	color.a = 0.50
	key.modulate = color

# moves key left, handled by scanner                
func move_left() -> void:
	transform.origin = transform.origin + Vector2(move_speed, 0)
