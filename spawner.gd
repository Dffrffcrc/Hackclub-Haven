extends Node2D

@export var dice_scene: PackedScene
@export var spawn_area: Rect2 = Rect2(Vector2(100, 100), Vector2(800, 400))
@export var wall_collision_mask: int = 1
@export var max_attempts: int = 25

@onready var timer: Timer = $SpawnTimer

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	spawn_dice()

func spawn_dice() -> void:
	if not dice_scene:
		push_warning("Dice scene not assigned to Spawner!")
		return

	var dice_instance := dice_scene.instantiate() as Area2D
	var col_shape := dice_instance.get_node("CollisionShape2D") as CollisionShape2D

	var space_state := get_world_2d().direct_space_state
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = col_shape.shape
	query.collision_mask = wall_collision_mask
	query.collide_with_bodies = true  
	query.collide_with_areas = true

	for attempt in range(max_attempts):
		var random_pos := Vector2(
				randf_range(spawn_area.position.x, spawn_area.end.x),
				randf_range(spawn_area.position.y, spawn_area.end.y)
		)

		var xform := Transform2D(0.0, random_pos + (col_shape.position * dice_instance.scale))
		query.transform = xform.scaled_local(dice_instance.scale)

		var collisions := space_state.intersect_shape(query, 1)

		if collisions.is_empty():
			dice_instance.global_position = random_pos
			dice_instance.z_index = 1 
			get_parent().add_child(dice_instance)
			return

	dice_instance.queue_free()
	push_warning("Could not find a wall-free spawn position after %d attempts." % max_attempts)
