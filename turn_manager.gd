extends Node

@onready var player1: RigidBody2D = $Node2D/Player1
@onready var player2: RigidBody2D = $Node2D/Player2
@onready var p1_score_rect: TextureRect = $CanvasLayer/P1Score
@onready var p2_score_rect: TextureRect = $CanvasLayer/P2Score
@onready var texture_rect: TextureRect = $Node2D/TextureRect

var current_turn: int = 1
var player1_score: int = 0
var player2_score: int = 0

func _ready() -> void:
	player1.turn_finished.connect(_on_turn_finished)
	player2.turn_finished.connect(_on_turn_finished)
	player1.collided.connect(_on_collision)
	player2.collided.connect(_on_collision)
	_update_score_display()
	start_turn(1)

func start_turn(player_num: int) -> void:
	current_turn = player_num
	player1.can_drag = (player_num == 1)
	player2.can_drag = (player_num == 2)
	player1.modulate.a = 1.0 if current_turn == 1 else 0.5
	player2.modulate.a = 1.0 if current_turn == 2 else 0.5

func _on_turn_finished() -> void:
	start_turn(2 if current_turn == 1 else 1)

func _on_collision(body: Node) -> void:
	if body.name == "Player2":
		player2_score += 1
	elif body.name == "Player1":
		player1_score += 1
	_update_score_display()

func _update_score_display() -> void:
	p1_score_rect.texture = load("res://Assets/scores/red%d.png" % clampi(player1_score, 0, 9)) if player1_score > -1 else null
	p2_score_rect.texture = load("res://Assets/scores/blue%d.png" % clampi(player2_score, 0, 9)) if player2_score > -1 else null
	
	if player1_score == 10 || player2_score == 10:
		if player1_score > player2_score:
			texture_rect.texture = load("res://Assets/scores/redWinEndscreen.png")
		elif player1_score < player2_score:
			texture_rect.texture = load("res://Assets/scores/blueWinEndscreen.png")
		player1.visible = false
		player2.visible = false
		p1_score_rect.visible = false 
		p2_score_rect.visible = false
