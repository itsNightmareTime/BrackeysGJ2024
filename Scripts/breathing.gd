extends Node2D

# Handles the breathing state. The animation_names index correspond with the breathingState values
enum breathingState {
	breathe_in,
	hold_breath,
	breathe_out,
	pause
}
var animation_names = ["breathe_in", "hold_breath", "breathe_out", "pause"]

signal bad_breathing
signal hyperventilating 
@onready var hyperventilation: Timer = $hyperventilation
var can_show_hyperventilation_text: bool = true
# lung animation player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
# Shader used for the outline indicator.
var glow_shader: Material = self.material
# loads the floating text scene for visual feedback
var floating_text = preload("res://Scenes/floating_text.tscn")

# Handles the breathing states of the animation
var init_breath_state: breathingState = breathingState.breathe_in
var current_breath_state: breathingState

# changes the speed by changing the animation speed_scale
@export var current_breath_speed: float = 1.0
const max_lung_speed: float = 3.25
const min_lung_speed: float = 0.5
var hyperventilating_speed: float = 0.90 * max_lung_speed # considered hyperventilating if breathing at 60% lung speed
const breathing_speed_increment: float = 0.001
const breathing_speed_success: float = 0.35
const breathing_failure_speed_increment: float = 0.35

var can_breath_in: bool = true 
var is_breathing_in: bool = false
var let_go_of_breath: bool = true
var let_go_early: bool = false
var can_breathe_again: bool = true

func _ready() -> void:
	hyperventilation.start()
	current_breath_state = init_breath_state
	animation_player.speed_scale = current_breath_speed
	animation_player.play(animation_names[current_breath_state])
	
	if glow_shader is ShaderMaterial:
		var glow_shader = glow_shader as ShaderMaterial
		shader_highlighted()

func _process(_delta: float) -> void:
	check_for_hyperventilation()
	# If the player keeps holding the mouse button after a failed breath this stops them from breathing in again
	if not let_go_of_breath and not can_breath_in:
		shader_off()
		can_breathe_again = false
		
	# When the player releases the mouse button it allows them to breath in again next cycle
	# This also tracks if the player released too early during a breath or waited out the animation
	if Input.is_action_just_released("breathing"):
		if can_breath_in and is_breathing_in:
			let_go_early = true
			bad_breathing.emit()
			if can_breathe_again:
				speed_up_lung_speed(breathing_failure_speed_increment)
				spawn_feedback_text("bad!", "red")
			can_breathe_again = false
		else:
			can_breathe_again = true
		is_breathing_in = false
		let_go_of_breath = true
		shader_off()
		if let_go_early:
			pass
		else:
			can_breathe_again = true
	
	# Tracks when the player is holding in a breath. Can only happen as long as they didn't already try to
	# breathe during this animation cycle and the current animation is either breathing in or holding breath
	if Input.is_action_pressed("breathing") and can_breath_in and can_breathe_again and not let_go_early:
		is_breathing_in = true
		let_go_of_breath = false
		slow_down_lung_speed(breathing_speed_increment)
		shader_breathing()

# changes the shader outline to indicate that the player is holding their breath 
func shader_breathing() -> void:
	glow_shader.set_shader_parameter("is_breathing", true)
	glow_shader.set_shader_parameter("shader_on", true)

# changes the shader outline to indicate that the player can hold their breath now
func shader_highlighted() -> void:
	glow_shader.set_shader_parameter("is_breathing", false)
	glow_shader.set_shader_parameter("shader_on", true)

# removes the shader visibility to show that a breath can no longer be held, either
# because the animation is over or the player let go too early during the breath
func shader_off() -> void:
	glow_shader.set_shader_parameter("shader_on", false)

func check_for_hyperventilation() -> void:
	if current_breath_speed >= hyperventilating_speed:
		hyperventilating.emit()
		if can_show_hyperventilation_text:
			spawn_feedback_text("Slow your breath!", "red")
			can_show_hyperventilation_text = false

func speed_up_lung_speed(increment: float) -> void:
	current_breath_speed += increment
	if current_breath_speed >= max_lung_speed:
		current_breath_speed = max_lung_speed
	animation_player.speed_scale = current_breath_speed
	
func slow_down_lung_speed(increment: float) -> void:
	current_breath_speed -= increment
	if current_breath_speed <= min_lung_speed:
		current_breath_speed = min_lung_speed
	animation_player.speed_scale = current_breath_speed
	
func spawn_feedback_text(text : String, color : String) -> void:
	# Create an instance of the scene
	var floating_text_instance = floating_text.instantiate()

	# Calculate the position to be right above and centered with the spawning node
	var spawn_position = self.position 
	floating_text_instance.position = spawn_position

	# Add the instance to the scene tree
	add_child(floating_text_instance)

	# Call the set_and_start function on the instance
	floating_text_instance.set_and_start(text, color)

# signal occurs when an animation ends and then cycles the current animation to the next state and plays it
# it will also change the logic on if a player can even attempt to breathe in again or not
func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if current_breath_state == breathingState.pause:
		current_breath_state = breathingState.breathe_in
	else:
		current_breath_state += 1
		
	if current_breath_state == breathingState.breathe_in:
		can_breath_in = true
		let_go_early = false
		if can_breathe_again:
			shader_highlighted()
		
	if current_breath_state == breathingState.breathe_out:
		can_breath_in = false
		if is_breathing_in and can_breathe_again:
			slow_down_lung_speed(breathing_speed_success)
			spawn_feedback_text("good!", "blue")
		if not is_breathing_in:
			can_breathe_again = true
		shader_off()
		
	animation_player.play(animation_names[current_breath_state])


func _on_hyperventilation_timeout() -> void:
	can_show_hyperventilation_text = true
