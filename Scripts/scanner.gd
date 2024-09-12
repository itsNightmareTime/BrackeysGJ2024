extends Node2D

enum frustration_level {
	one,
	two,
	three,
	four,
	five
}

@onready var key_scene = preload("res://Scenes/key.tscn")
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

const key_path: String = "res://Assets/Keys/"
const key_extension: String = ".png"
const key_blank_path: String = key_path + "Blank" + key_extension
const level_one_key_map: Array[String] = ["W", "A", "S", "D", "Blank"]
const level_two_key_map: Array[String] = ["W", "A", "S", "D", "Q", "E", "F", "R", "Blank", "Blank", "Blank"]
const level_three_key_map: Array[String] = ["W", "A", "S", "D", "Q", "E", "F", "R", "Z", "X","C", "V", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank"]
const level_four_key_map: Array[String] = ["W", "A", "S", "D", "Q", "E", "F", "R", "Z", "X","C", "V", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", 
"Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "T", "G", "B", "Y", "H", "N", "1", 
"2", "3", "4", "5", "6"]
const level_five_key_map: Array[String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "Blank",
"Blank", "Blank", "Blank", "Blank","Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", 
"Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", 
"Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "Blank", "N", "O", "P", "Q", "R", "S", 
"T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

# distance for where to spawn keys and how far apart they need to be from each other
var x_distance_between_keys: float = 100.0
var key_start_y: float = -4.0
var key_start_x: float = 1000

# current state of the cart variables
var current_frustration = frustration_level.five
var current_key_map = level_one_key_map
var current_cart: Array[Item_Key]
var current_cart_size: int
var current_key_num: int = 0
var total_items_scanned: int = 0
var in_queue: bool = false

# Input timer variables
var input_timer: Timer = Timer.new()
var input_timer_wait_time: float = 0.05
var input_available: bool = true
var randomGen = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# generating the timer used for input
	input_timer.wait_time = input_timer_wait_time
	input_timer.one_shot = true
	input_timer.connect("timeout", Callable(self, "_on_Input_Timer_Timeout"))
	add_child(input_timer)
	
	#cart testing
	current_cart = generate_shopping_cart()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_queue:
		# checks for input as long as there are still in queue
		if not current_key_num >= current_cart_size:
			# gets the current key's identity as a string then uses OS to convert it to a keycode for the Input function
			var current_key_identity: Key = OS.find_keycode_from_string(current_cart[current_key_num].key_identity)
			current_cart[current_key_num].set_alpha_active_key()
			if Input.is_physical_key_pressed(current_key_identity) and input_available:
				current_cart[current_key_num].set_alpha_key_in_queue()
				audio_stream_player_2d.play()
				move_cart_by_one_key(current_cart)
				total_items_scanned += 1
				current_key_num += 1
				input_available = false
				input_timer.start()
		# frees the keys from queue and sends them left to the KeyDeleter
		else:
			in_queue = false
			move_or_stop_cart(current_cart, true)
			
# change the current key_map based on the current frustration level
func update_frustration_level() -> void:
	match current_frustration:
		frustration_level.one:
			current_key_map = level_one_key_map
		frustration_level.two:
			current_key_map = level_two_key_map
		frustration_level.three:
			current_key_map = level_three_key_map
		frustration_level.four:
			current_key_map = level_four_key_map
		frustration_level.five:
			current_key_map = level_five_key_map
		_:
			print("Error: frustration level incorrect")
	
func set_frustration_level(level : int) -> void:
	if level < 1:
		current_frustration = 1
	elif level > 5:
		current_frustration = 5
	else:
		current_frustration = level

# creates and returns a Key. Takes in the Char key name
# the key_name is differenty from identity because of blank keys
# the key_name will change the sprite and the identity will determine the input needed
func create_key(key_name: String, identity: String) -> Item_Key:
	var new_key: Item_Key = key_scene.instantiate()
	var filename: String = key_path + key_name + key_extension
	add_child(new_key)
	new_key.set_key_type(filename, identity)
	return new_key
	
# generates a random key based on the current_key_map. It handles Blank keys that have
# a different key_name and identity
func generate_rand_key() -> Item_Key:
	randomGen.randomize()
	var key_name: String
	var key_identity: String
	var key_identity_index: int = randomGen.randi_range(0, current_key_map.size()-1) #randi is inclusive so we must subtract 1
	if current_key_map[key_identity_index] == "Blank":
		key_name = "Blank"
		while current_key_map[key_identity_index] == "Blank":
			randomGen.randomize()
			key_identity_index = randomGen.randi_range(0, current_key_map.size()-1)
		key_identity = current_key_map[key_identity_index]
		
	else:
		key_name = current_key_map[key_identity_index]
		key_identity = key_name
	return create_key(key_name, key_identity)
	
# Generates an array of keys that make up the customer's "Shopping cart". min is one item, 
# max changes based on the current frustration level. 
func generate_shopping_cart() -> Array[Item_Key]:
	update_frustration_level()
	randomGen.randomize()
	var num_items: int = randomGen.randi_range(1, 4)
	randomGen.randomize()
	var frustration_increase: int = randomGen.randi_range(0, current_frustration)
	current_cart_size = num_items + frustration_increase
	var new_cart: Array[Item_Key]
	for i in range(current_cart_size):
		var new_key: Item_Key = generate_rand_key()
		new_cart.append(new_key)
	current_key_num = 0
	put_cart_in_queue(new_cart)
	return new_cart
	
func put_cart_in_queue(cart: Array[Item_Key]) -> void:
	var current_pos = Vector2(key_start_x, key_start_y)
	for key in cart:
		key.transform.origin = current_pos
		current_pos.x += x_distance_between_keys
		
func move_or_stop_cart(cart: Array[Item_Key], can_move: bool) -> void:
	for key in cart:
		key.can_move = can_move	

func move_cart_by_one_key(cart: Array[Item_Key]) -> void:
	for key in cart:
		key.transform.origin.x -= x_distance_between_keys
	
# when an area_2d enters the active_key_UI
func _on_area_2d_area_entered(area: Area2D) -> void:
	if not in_queue:
		move_or_stop_cart(current_cart, false)
		in_queue = true

# when an area enters the key_deleter, generate new cart and delete this one
func _on_key_deleter_area_entered(area: Area2D) -> void:
	area.get_parent().queue_free()
	
func _on_Input_Timer_Timeout():
	input_available = true
