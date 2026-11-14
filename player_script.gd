extends RigidBody2D

signal turn_finished
signal collided(body: Node)
@export var launch_power: float = 35.0
@export var max_arrow_length: float = 300.0
@export var stop_threshold: float = 20 # Speed below which the ball counts as stopped
var has_launched: bool = false
@onready var aim_arrow: Line2D = $AimArrow
@export var min_drag_distance: float = 15.0
var drag_start: Vector2 = Vector2.ZERO
var is_dragging: bool = false
var can_drag: bool = false
var is_moving: bool = false

func _ready() -> void:
	contact_monitor = true  
	max_contacts_reported = 5
	freeze = true
	aim_arrow.position = $Sprite2D.position
	lock_rotation = true
	aim_arrow.visible = false
	aim_arrow.clear_points()
	aim_arrow.add_point(Vector2.ZERO)
	aim_arrow.add_point(Vector2.ZERO)
	body_entered.connect(_on_body_entered)
func _on_body_entered(body: Node) -> void:
	print("Collided")
	collided.emit(body)
	
func _physics_process(_delta: float) -> void:
	if not is_moving:
		return

	if not has_launched:
		if linear_velocity.length() >= stop_threshold:
			has_launched = true
		return

	if linear_velocity.length() < stop_threshold:
		is_moving = false
		has_launched = false
		linear_velocity = Vector2.ZERO
		freeze = true
		turn_finished.emit()

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if not can_drag:
		return

	if (event is InputEventScreenTouch and event.pressed) or \
	   (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		drag_start = event.position
		is_dragging = true
		aim_arrow.set_point_position(1, Vector2.ZERO)
		aim_arrow.visible = true
		get_viewport().set_input_as_handled()

func _input(event: InputEvent) -> void:
	if not is_dragging:
		return

	if event is InputEventScreenDrag or event is InputEventMouseMotion:
		var drag_vector: Vector2 = drag_start - event.position
		var arrow_end: Vector2 = drag_vector.limit_length(max_arrow_length)
		aim_arrow.set_point_position(1, arrow_end)

	elif (event is InputEventScreenTouch and not event.pressed) or \
		 (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed):
		aim_arrow.position = $Sprite2D.position
		is_dragging = false
		can_drag = false # Lock dragging immediately once shot
		
		aim_arrow.visible = false
		launch(drag_start, event.position)

func launch(start_pos: Vector2, end_pos: Vector2) -> void:
	var drag_vector: Vector2 = start_pos - end_pos

	if drag_vector.length() < min_drag_distance:
		can_drag = true
		return

	print(drag_vector)
	freeze = false
	is_moving = true
	apply_central_impulse(drag_vector.limit_length(max_arrow_length) * launch_power)
