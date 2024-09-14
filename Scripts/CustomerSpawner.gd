extends Node2D

@export_category("Path Config")
# Designates if the path should spawn a customer
@export var is_spawner: bool = false
# Array of Character scenes that can be used
@export var customer_variants: Array[PackedScene] = []
# The next path to move through
@export var next_path: Path2D = null
# Is this the exit
@export var is_exit: bool = false

@onready var scanner: Node2D = $"../Scanner"
var current_customer = null

signal at_register

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Spawns a new customer if they are in the next path and out of the way
func _process(_delta: float):
	if not current_customer and is_spawner:
		spawn_new_customer()
		scanner.cart_empty.connect(move_customer_to_next_path)

# Create a new customer a connect to the at_end signal.
func spawn_new_customer():
	var new_customer = customer_variants.pick_random().instantiate()
	new_customer.move_speed = 250
	current_customer = new_customer
	add_child(new_customer)

# Move the customer to the next path is specified and reset their progress 
# and stop listening for their at end signal
func move_customer_to_next_path():
	current_customer.reparent(next_path)
	current_customer.progress = 0
	current_customer.at_end_of_path = false
	current_customer = null
