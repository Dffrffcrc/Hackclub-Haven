extends Control

@onready var breakpoint_btn: TextureButton = $background/breakpointButton
@onready var duality_btn: TextureButton = $background/dualityButton
@onready var crossfire_btn: TextureButton = $background/crossfireButton

func _ready() -> void:
	breakpoint_btn.pressed.connect(get_tree().change_scene_to_file.bind("res://scenes/breakpoint.tscn"))
	duality_btn.pressed.connect(get_tree().change_scene_to_file.bind("res://scenes/duality.tscn"))
	crossfire_btn.pressed.connect(get_tree().change_scene_to_file.bind("res://scenes/crossfire.tscn"))
