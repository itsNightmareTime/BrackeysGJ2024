extends Node2D

@onready var final_score_value: RichTextLabel = $final_score_value
@onready var clock_total: RichTextLabel = $clock_icon/clock_total
@onready var item_total: RichTextLabel = $item_icon/item_total
@onready var customer_total: RichTextLabel = $customer_icon/customer_total
@onready var clock_multiply_value: RichTextLabel = $clock_multiply/clock_multiply_value
@onready var item_multiply_value: RichTextLabel = $item_multiply/item_multiply_value
@onready var customer_multiply_value: RichTextLabel = $customer_multiply/customer_multiply_value
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var outer_margin: MarginContainer = $buttons/CanvasLayer/OuterMargin

@export var main_menu: String = "res://Scenes/MainMenu.tscn"
@export var clock_multiplier: int = 10
@export var item_multiplier: int = 5
@export var customer_multiplier: int = 20
var final_score: int

func _ready() -> void:
	outer_margin.visible = false
	
func set_score_board(seconds: int, items: int, customers: int) -> void:
	clock_total.text = str(seconds)
	clock_multiply_value.text = str(clock_multiplier)
	item_total.text = str(items)
	item_multiply_value.text = str(item_multiplier)
	customer_total.text = str(customers)
	customer_multiply_value.text = str(customer_multiplier)
	final_score = (seconds * clock_multiplier) + (items * item_multiplier) + (customers * customer_multiplier)
	final_score_value.text = str("%05d" % final_score)
	
	visible = true
	outer_margin.visible = true
	animation_player.play("appear")
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file(main_menu)
