extends Node
@onready var player1: RigidBody2D = $Player1
@onready var player2: RigidBody2D = $Player2

# Called when the node enters the scene tree for the first time.
var current_turn: int = 1

func _ready() -> void:
	player1.turn_finished.connect(_on_turn_finished)
	player2.turn_finished.connect(_on_turn_finished)
	start_turn(1)
func start_turn(player_num: int) -> void:
	current_turn = player_num
	player1.can_drag = (player_num == 1)
	player2.can_drag = (player_num == 2)
	player1.modulate.a = 1.0 if current_turn == 1 else 0.5
	player2.modulate.a = 1.0 if current_turn == 2 else 0.5

func _on_turn_finished() -> void:
	var next_player: int = 2 if current_turn == 1 else 1
	start_turn(next_player)
