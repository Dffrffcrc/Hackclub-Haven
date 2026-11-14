extends Node
@onready var player1: RigidBody2D = $Node2D/Player1
@onready var player2: RigidBody2D = $Node2D/Player2
@onready var score_label: Label = $CanvasLayer/Scores
# Called when the node enters the scene tree for the first time.
var current_turn: int = 1
var player1_score = 0
var player2_score = 0
func _ready() -> void:
	player1.turn_finished.connect(_on_turn_finished)
	player2.turn_finished.connect(_on_turn_finished)
	player1.collided.connect(_on_collision)
	player2.collided.connect(_on_collision)
	update_score_display()
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
func _on_collision(body: Node) -> void:
	if body.name == "Player2":
		player1_score+=1
	elif body.name == "Player1":
		player2_score+=1
	update_score_display()
	print("Collision with ", body.name)
	print("Player 1 Score", player1_score)
	print("Player 2 Score", player2_score)
func update_score_display() -> void:
	score_label.text = "Player 1: %d | Player 2: %d" % [player1_score, player2_score]