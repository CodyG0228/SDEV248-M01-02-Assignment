extends Node

var score = 0
var lives = 5

signal score_changed
signal lives_changed

func _ready() -> void:
	score = 0
	lives = 5

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit()

func lose_life() -> void:
	lives = max(lives - 1, 0)
	lives_changed.emit()

func is_game_over() -> bool:
	return lives <= 0
