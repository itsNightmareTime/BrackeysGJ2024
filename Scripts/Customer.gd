extends PathFollow2D
class_name Customer

@export var move_speed: int = 200:
	set(value):
		move_speed = value

func _ready():
	loop = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	progress = progress + (move_speed * delta)
	if progress_ratio == 1:
		free()
