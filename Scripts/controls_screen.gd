extends Node2D


@export var menu_scene: String = "res://Scenes/MainMenu.tscn"

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(menu_scene)
