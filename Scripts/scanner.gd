extends Node2D

enum frustration_level {
	one,
	two,
	three,
	four,
	five
}

@onready var key_scene = preload("res://Scenes/key.tscn")

const key_path: String = "res://Assets/Keys/"
const key_extension: String = ".png"
const key_blank_path: String = key_path + "Blank" + key_extension
const level_one_key_map: Array[String] = ["W", "A", "S", "D"]
const level_two_key_map: Array[String] = ["W", "A", "S", "D", "Q", "E", "F", "R"]
const level_three_key_map: Array[String] = ["W", "A", "S", "D", "Q", "E", "F", "R", "Z", "X","C", "V", "Blank"]
const level_four_key_map: Array[String] = ["W", "A", "S", "D", "Q", "E", "F", "R", "Z", "X","C", "V", "Blank", 
"T", "G", "B", "Y", "H", "N", "1", "2", "3", "4", "5", "6"]
const level_five_key_map: Array[String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "Blank", 
"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

var current_frustration = frustration_level.one
var current_key_map = level_one_key_map
var randomGen = RandomNumberGenerator.new()

var test_cart: Array[Key]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	test_cart = generate_shopping_cart()
	put_cart_in_queue(test_cart)
	#create_key("B", "B")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_cart(test_cart)

# creates and returns a Key. Takes in the Char key name
# the key_name is differenty from identity because of blank keys
# the key_name will change the sprite and the identity will determine the input needed
func create_key(key_name: String, identity: String) -> Key:
	var new_key: Key = key_scene.instantiate()
	var filename: String = key_path + key_name + key_extension
	add_child(new_key)
	new_key.set_key_type(filename, identity)
	return new_key
	
# generates a random key based on the current_key_map. It handles Blank keys that have
# a different key_name and identity
func generate_rand_key() -> Key:
	randomGen.randomize()
	var key_name: String
	var key_identity: String
	var key_identity_index: int = randomGen.randi_range(0, current_key_map.size()-1) #randi is inclusive so we must subtract 1
	if current_key_map[key_identity_index] == "Blank":
		key_name = "Blank"
		while current_key_map[key_identity_index] == "Blank":
			randomGen.randomize()
			key_identity_index = randomGen.randi_range(0, current_key_map.length-1)
		key_identity = current_key_map[key_identity_index]
		
	else:
		key_name = current_key_map[key_identity_index]
		key_identity = key_name
	return create_key(key_name, key_identity)
	
# Generates an array of keys that make up the customer's "Shopping cart". min is one item, 
# max changes based on the current frustration level. 
func generate_shopping_cart() -> Array[Key]:
	randomGen.randomize()
	var num_items: int = randomGen.randi_range(1, 4)
	randomGen.randomize()
	var frustration_increase: int = randomGen.randi_range(0, current_frustration)
	var total_items: int = num_items + frustration_increase
	var new_cart: Array[Key]
	for i in range(total_items):
		var new_key: Key = generate_rand_key()
		new_cart.append(new_key)
		print(new_key)
	print(new_cart)
	return new_cart
	
func put_cart_in_queue(cart: Array[Key]) -> void:
	var x_distance_between_keys: float = 100.0
	var key_y: float = -4.0
	var key_x: float = 1000
	var current_pos = Vector2(key_x, key_y)
	for key in cart:
		key.transform.origin = current_pos
		current_pos.x += x_distance_between_keys
		

func move_cart(cart: Array[Key]) -> void:
	for key in cart:
		key.move_left()
	
