extends Area2D

signal picked_up_dice(body: RigidBody2D)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_entered)
	pass # Replace with function body.
func _on_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		print("HIT!", body.name)
		var random_angle := randf() * TAU
		var random_direction := Vector2.from_angle(random_angle)
		
		# Keep the ball's current speed (with a minimum of 800 px/s) and redirect it completely
		var new_speed := 1000.0
		body.linear_velocity = random_direction * new_speed
		
		picked_up_dice.emit(body)
		queue_free()
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
