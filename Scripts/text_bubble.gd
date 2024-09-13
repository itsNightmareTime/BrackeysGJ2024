extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label_text: RichTextLabel = $Sprite2D/text

var animation_name: String = "pop_out"

var comments: Array = [
		"this place stinks so much it makes me sick.",
		"There's nothing good here.",
		"Why are there so many people here?",
		"This cashier is incompetent",
		"can this be any slower?",
		"Why do they always hire the rejects?",
		"This is way too expensive!",
		"such a rip off!",
		"I just farted.",
		"UGH! HURRY UP!",
		"You people are always so slow!",
		"Can't they go any faster?",
		"This job is so easy! How are they this slow!",
		"I just spilled this drink everywhere",
		"People just don't want to work anymore!",
		"Laziest Cashier I've ever seen",
		"I think I broke the toilet when I was in there",
		"You can tell they didn't graduate high school...",
		"Can I cut in line? I'm in a hurry",
		"I don't see a barcode on this, is it free?"
	]

func pop_out() -> void:
	visible = true
	label_text.text = comments.pick_random()	
	animation_player.play(animation_name)
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	visible = false
	animation_player.stop()
