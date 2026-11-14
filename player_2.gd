extends RigidBody2D

@export var launch_power: float = 5.0

var drag_start: Vector2 = Vector2.ZERO
var is_dragging: bool = false

func _ready() -> void:
	freeze = true

# This triggers when clicking directly on the ball's collision shape
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventScreenTouch and event.pressed) or \
	   (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		# Capture the ball's actual current world position right when clicked
		drag_start = global_position 
		is_dragging = true
		print("Drag Started at: ", drag_start)

func _input(event: InputEvent) -> void:
	if is_dragging:
		if event is InputEventScreenDrag or event is InputEventMouseMotion:
			var current_mouse: Vector2 = get_global_mouse_position()
			print("Current Mouse: ", current_mouse)

		elif (event is InputEventScreenTouch and not event.pressed) or \
			 (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed):
			is_dragging = false
			
			var end_pos: Vector2 = get_global_mouse_position()
			launch(drag_start, end_pos)

func launch(start_pos: Vector2, end_pos: Vector2) -> void:
	# If you want it to launch AWAY from where you pull (classic slingshot style):
	var drag_vector: Vector2 = start_pos - end_pos
	
	# If you want it to launch TOWARD where you drag instead, uncomment the line below:
	# var drag_vector: Vector2 = end_pos - start_pos
	
	print("--- LAUNCHED ---")
	print("Drag Vector: ", drag_vector)
	
	freeze = false
	apply_central_impulse(drag_vector * launch_power)
