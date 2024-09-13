extends PathFollow2D
class_name Customer

signal at_end

@export var move_speed: int = 200
var at_end_of_path: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	progress = progress + (move_speed * delta)
	if progress_ratio == 1 and not at_end_of_path:
		at_end_of_path = true
		if not get_parent().is_exit:
			var signal_emitted = emit_signal("at_end", self)
		else:
			free()
