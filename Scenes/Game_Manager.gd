extends Node2D

@onready var lungs: Node2D = $Lungs
@onready var scanner: Node2D = $Scanner
@onready var frustration_ui: Node2D = $Frustration_UI
@onready var customer_path_line_to_register: Path2D = $CustomerPathLineToRegister
@onready var customer_path_exit: Path2D = $CustomerPathExit
@onready var clock: Node2D = $Clock

@export var max_frustration: float = 100
@export var min_frustration: float = 1
var current_frustration: float = min_frustration
# used to convert the frustration to lung_speed values by dividing current_frustration by this
@export var lung_speed_increment_divisor: float = 50000
@export var clock_frustration_increment: float = 0.334 # makes the longest possible game 5 minutes
@export var bad_breath_frustration_increment: float = 0.334
@export var hyperventilation_frustration_increment: float = 0.334
var current_lung_speed_increment: float = current_frustration / lung_speed_increment_divisor
var hyperventilation_increment_timer: Timer = Timer.new()
var can_add_hyper_increment: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hyperventilation_increment_timer.wait_time = 1.0
	hyperventilation_increment_timer.one_shot = true
	hyperventilation_increment_timer.connect("timeout", Callable(self, "_on_Hyper_Timer_Timeout"))
	add_child(hyperventilation_increment_timer)
	hyperventilation_increment_timer.start()
	scanner.generate_shopping_cart()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#update_frustration()
	update_lungs()
	update_scanner()
	update_frustration_ui()
	
func update_frustration() -> void:
	var new_frustration = clock.time_elapsed * clock_frustration_increment
	if new_frustration > 100:
		new_frustration = 100
	current_frustration += new_frustration
	
func update_lungs() -> void:
	var new_increment: float = current_frustration / lung_speed_increment_divisor
	lungs.speed_up_lung_speed(new_increment)
	
func update_frustration_ui() -> void:
	frustration_ui.update_frustration(int(current_frustration))
	
func update_scanner() -> void:
	scanner.set_frustration_level(current_frustration)

# Emitted from the cart once the last item has been scanned
func _on_scanner_cart_empty() -> void:
	scanner.generate_shopping_cart()

# Emiited when the player breathes poorly
func _on_lungs_bad_breathing() -> void:
	increase_frustration(bad_breath_frustration_increment)

func _on_lungs_hyperventilating() -> void:
	if can_add_hyper_increment:
		increase_frustration(hyperventilation_frustration_increment)
		can_add_hyper_increment = false

func _on_clock_one_second() -> void:
	increase_frustration(clock_frustration_increment)
	
func increase_frustration(increment: float) -> void:
	if current_frustration + increment > 100:
		current_frustration = 100
	current_frustration += increment
	
func _on_Hyper_Timer_Timeout() -> void:
	can_add_hyper_increment = true
	hyperventilation_increment_timer.start()
