extends Area2D

signal picked_up_dice(body: RigidBody2D)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_entered)
	pass # Replace with function body.
func _on_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		print("HIT!")
		picked_up_dice.emit(body)
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
