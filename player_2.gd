extends RigidBody2D

@export var launch_power: float = 20.0
@export var max_arrow_length: float = 300.0 # Caps how long the line can stretch

@onready var aim_arrow: Line2D = $AimArrow
@onready var Sprite
var drag_start: Vector2 = Vector2.ZERO
var is_dragging: bool = false

func _ready() -> void:
	freeze = true
	aim_arrow.position = $Sprite2D.position
	lock_rotation = true

	# Ensure the Line2D starts hidden and has 2 points ready
	aim_arrow.visible = false
	aim_arrow.clear_points()
	aim_arrow.add_point(Vector2.ZERO) # Point 0: Center of the RigidBody2D
	aim_arrow.add_point(Vector2.ZERO) # Point 1: Tip of the aim line

func _input(event: InputEvent) -> void:
	if (event is InputEventScreenTouch and event.pressed) or \
	   (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		drag_start = event.position
		is_dragging = true
		
		# Reset tip to center and show the line
		aim_arrow.set_point_position(1, Vector2.ZERO)
		aim_arrow.visible = true

	elif is_dragging and (event is InputEventScreenDrag or event is InputEventMouseMotion):
		var current_coords: Vector2 = event.position
		var drag_vector: Vector2 = drag_start - current_coords
		var arrow_end: Vector2 = drag_vector.limit_length(max_arrow_length)
		aim_arrow.set_point_position(1, arrow_end)

	elif is_dragging and ((event is InputEventScreenTouch and not event.pressed) or \
		 (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed)):
		aim_arrow.position = $Sprite2D.position
		is_dragging = false
		aim_arrow.visible = false # Hide the arrow once launched
		launch(drag_start, event.position)

func launch(start_pos: Vector2, end_pos: Vector2) -> void:
	var drag_vector: Vector2 = start_pos - end_pos
	
	freeze = false
	apply_central_impulse(drag_vector * launch_power)
