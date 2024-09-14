extends Node2D
@onready var rich_text_label: RichTextLabel = $Sprite2D/RichTextLabel

func update_text(new_text: String) -> void:
	rich_text_label.text = new_text
