extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var lives_label: Label = $LivesLabel

@onready var game: Node = get_node("/root/Game")

func _ready() -> void:
	game.score_changed.connect(_update_score)
	game.lives_changed.connect(_update_lives)
	_update_score()
	_update_lives()

func _update_score() -> void:
	score_label.text = "Coke Zeroes: %d" % game.score

func _update_lives() -> void:
	lives_label.text = "Lives: %d" % game.lives
