extends Node

@export var game_scene: String = "res://Scenes/Game.tscn"
@export var setting_scene: String = "res://Scenes/Credits.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_start_button_pressed():
	get_tree().change_scene_to_file(game_scene)

func _on_exit_button_pressed():
	get_tree().quit()

func _on_button_pressed():
	get_tree().change_scene_to_file(setting_scene)
