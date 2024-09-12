extends Node2D

@onready var path := $CustomerPath

@export_category("Spawner Config")
# The max amount of customers to spawn
@export var num_customers: int
# Time in seconds between spawns
@export var spawn_rate: int
@export var customer_variants: Array[PackedScene] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in customer_variants:
		var new_customer = x.instantiate()
		new_customer.move_speed = (randi_range(200, 350))
		path.add_child(new_customer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	pass
