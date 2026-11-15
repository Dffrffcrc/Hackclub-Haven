extends Node

@onready var player1: RigidBody2D = $Node2D/Player1
@onready var player2: RigidBody2D = $Node2D/Player2
@onready var p1_score_rect: TextureRect = $CanvasLayer/P1Score
@onready var p2_score_rect: TextureRect = $CanvasLayer/P2Score
@onready var texture_rect: TextureRect = $Node2D/TextureRect
@onready var reset_btn: TextureButton = $CanvasLayer/ResetBtn
@onready var timer_label: Label = $CanvasLayer/TimerLabel
@onready var bounce_audio: AudioStreamPlayer2D = $Node2D/BounceAudio
var current_turn: int = 1
var player1_score: int = 0
var player2_score: int = 0
var time_left: float = 90.0

func _ready() -> void:
	#testing:
	for child in $CanvasLayer.get_children():
		if child.name.begins_with("inner"):
			child.collision_layer = 1
		
	player1.turn_finished.connect(_on_turn_finished)
	player2.turn_finished.connect(_on_turn_finished)
	player1.collided.connect(_on_collision)
	player2.collided.connect(_on_collision)
	reset_btn.pressed.connect(get_tree().reload_current_scene)
	reset_btn.hide()
	_update_score_display()
	start_turn(1)

func _process(delta: float) -> void:
	time_left = maxf(time_left - delta, 0.0)
	timer_label.text = "%d:%02d" % [int(ceil(time_left)) / 60, int(ceil(time_left)) % 60]
	if time_left == 0.0:
		_update_score_display()

func start_turn(player_num: int) -> void:
	current_turn = player_num
	player1.can_drag = (player_num == 1)
	player2.can_drag = (player_num == 2)
	player1.modulate.a = 1.0 if current_turn == 1 else 0.5
	player2.modulate.a = 1.0 if current_turn == 2 else 0.5

func _on_turn_finished() -> void:
	start_turn(2 if current_turn == 1 else 1)

func _on_collision(body: Node) -> void:
	print("Collision with ", body.name)
	if body.name == "Player2":
		player2_score += 1
	elif body.name == "Player1":
		player1_score += 1
	bounce_audio.play()
	_update_score_display()
	

func _update_score_display() -> void:
	p1_score_rect.texture = load("res://Assets/scores/red%d.png" % clampi(player1_score, 0, 9)) if player1_score > -1 else null
	p2_score_rect.texture = load("res://Assets/scores/blue%d.png" % clampi(player2_score, 0, 9)) if player2_score > -1 else null
	
	if player1_score >= 10 or player2_score >= 10 or time_left <= 0.0:
		set_process(false)
		if player1_score > player2_score:
			texture_rect.texture = load("res://Assets/scores/redWinEndscreen.png")
		elif player1_score < player2_score:
			texture_rect.texture = load("res://Assets/scores/blueWinEndscreen.png")
		else:
			texture_rect.texture = load("res://Assets/scores/tieEndScreen.png")
		player1.visible = false
		player2.visible = false
		p1_score_rect.visible = false 
		p2_score_rect.visible = false
		timer_label.visible = false
		reset_btn.show()
