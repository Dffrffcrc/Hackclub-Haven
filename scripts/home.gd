extends Control

@onready var breakpoint_btn: TextureButton = $background/breakpointButton
@onready var duality_btn: TextureButton = $background/dualityButton
@onready var crossfire_btn: TextureButton = $background/crossfireButton
@onready var texture_button: TextureButton = $background/TextureButton

func _ready() -> void:
	breakpoint_btn.pressed.connect(_select_map.bind("res://scenes/breakpoint.tscn"))
	duality_btn.pressed.connect(_select_map.bind("res://scenes/duality.tscn"))
	crossfire_btn.pressed.connect(_select_map.bind("res://scenes/crossfire.tscn"))
	texture_button.pressed.connect(_select_map.bind("res://scenes/training.tscn"))

func _select_map(map_path: String) -> void:
	Global.selected_map_path = map_path
	get_tree().change_scene_to_file("res://scenes/game.tscn")
