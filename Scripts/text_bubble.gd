extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label_text: RichTextLabel = $Sprite2D/text
@onready var timer: Timer = $Timer

var animation_name: String = "pop_out"
var randomGen = RandomNumberGenerator.new()
var min_wait: float = 4.0
var max_wait: float = 12.0

var comments: Array =  [
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
		"I don't see a barcode on this, is it free?",
		"Why is this place always so crowded?",
		"The service here is terrible.",
		"I can't believe how rude the staff is.",
		"This line is taking forever.",
		"Do they even clean this place?",
		"The prices here are outrageous.",
		"I can't find anything I need.",
		"This store is a mess.",
		"Why is everything out of stock?",
		"The music here is too loud.",
		"I hate coming here.",
		"This place is a nightmare.",
		"The parking lot is always full.",
		"The aisles are too narrow.",
		"The lighting here is awful.",
		"The bathrooms are disgusting.",
		"The staff is so unhelpful.",
		"I can't believe how long the wait is.",
		"This place is so outdated.",
		"The products here are not cheap."
]
	
func _ready() -> void:
	randomGen.randomize()
	var new_wait_time = randomGen.randf_range(min_wait, max_wait)
	timer.wait_time = new_wait_time
	timer.start()

func pop_out() -> void:
	label_text.text = comments.pick_random()	
	animation_player.play(animation_name)
	visible = true
	
func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	animation_player.stop()
	visible = false


func _on_timer_timeout() -> void:
	pop_out()
	randomGen.randomize()
	var new_wait_time = randomGen.randf_range(min_wait, max_wait)
	timer.wait_time = new_wait_time
	timer.start()
