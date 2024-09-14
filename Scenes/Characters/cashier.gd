extends PathFollow2D

class_name Cashier

# a signal to emit when at the end of the path
signal at_end
@export var move_speed: int = 200
var at_end_of_path: bool = false
var game_over: bool = false
	
# Progress through the path until the end. If it is the exit deletes the customer if not emits I'm at the end.
# Will have to add a signal for at register to cause the scanning mini game to start?
func _process(delta: float):
	if game_over:
		progress = progress + (move_speed * delta)
		if progress_ratio == 1 and not at_end_of_path:
			at_end_of_path = true
			free()
