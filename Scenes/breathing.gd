extends Node2D

enum breathingState {
	breathe_in,
	hold_breath,
	breathe_out,
	pause
}

var animation_names = ["breathe_in", "hold_breath", "breathe_out", "pause"]

@export var init_breath_speed: float = 1.0
@export var init_breath_state: breathingState = breathingState.breathe_in
var current_breath_state: breathingState
var current_breath_speed: float
var auto_breathing: bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_breath_speed = init_breath_speed
	current_breath_state = init_breath_state
	animation_player.speed_scale = current_breath_speed
	animation_player.play(animation_names[current_breath_state])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# signal occurs when an animation ends and then cycles the current animation to the next state
# when auto breathing is on, the animations will automatically go the next state
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if auto_breathing:
		if current_breath_state == breathingState.pause:
			current_breath_state = breathingState.breathe_in
		else:
			current_breath_state += 1
		animation_player.play(animation_names[current_breath_state])
