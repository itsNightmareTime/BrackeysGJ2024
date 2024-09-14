extends Node2D

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var red = Color("FF1111")
var blue = Color("1111FF")

# Set the text and color (only "red" or "blue") of the label and it will play the animation and free itself
func set_and_start(text : String, color : String) -> void:
	label.text = text
	if color == "red":
		label.add_theme_color_override("font_color", red)
	else:
		label.add_theme_color_override("font_color", blue)
		
	animation_player.play("float")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	self.queue_free()
