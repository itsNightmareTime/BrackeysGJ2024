extends Node2D

class_name Item_Key # used to create this type of object so methods can be recognized in other scripts

@onready var key: Sprite2D = $Sprite2D
const key_path: String = "res://Assets/Keys/"
const blank_name: String = "res://Assets/Keys/Blank.png"
const key_extension: String = ".png"
var move_speed: float = -5.0
var key_identity: String
var can_move: bool = true
var blank_timer: Timer = Timer.new()
var randomGen = RandomNumberGenerator.new()

func _ready() -> void:
	set_alpha_key_in_queue()
	
func _process(_delta: float) -> void:
	if can_move:
		move_left()

# loads the image and turns it into a texture
func set_key_type(filename : String, identity : String) -> void:
	if filename == blank_name:
		create_blank_reveal_timer()
	var image = Image.load_from_file(filename)
	key.texture = ImageTexture.create_from_image(image)
	key_identity = identity

func create_blank_reveal_timer() -> void:
	randomGen.randomize()
	blank_timer.wait_time = randomGen.randf_range(3.0, 8.0)
	blank_timer.one_shot = true
	blank_timer.connect("timeout", Callable(self, "_on_Blank_Timer_Timeout"))
	add_child(blank_timer)
	blank_timer.start()

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

# moves key left, handled by scanner                
func move_left() -> void:
	transform.origin = transform.origin + Vector2(move_speed, 0)
	
func _on_Blank_Timer_Timeout():
	var filename: String = key_path + key_identity + key_extension
	set_key_type(filename, key_identity)
