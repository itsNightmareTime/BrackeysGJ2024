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

var current_customer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if not current_customer and is_spawner:
		spawn_new_customer()

func spawn_new_customer():
	var new_customer = customer_variants.pick_random().instantiate()
	new_customer.move_speed = 250
	current_customer = new_customer
	current_customer.at_end.connect(move_customer_to_next_path)
	add_child(new_customer)

# Move the customer to the next path is specified and reset their progress and stop listening for their at end signal
func move_customer_to_next_path(node: Node2D):
	print("received signal at_end")
	node.reparent(next_path)
	node.progress = 0
	node.at_end_of_path = false
	current_customer.at_end.disconnect(move_customer_to_next_path)
	current_customer = null
