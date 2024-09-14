extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func game_over() -> void:
	visible = true
	animation_player.play("appear")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "appear":
		animation_player.play("shake")
