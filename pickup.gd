extends Area2D

const VALUE = 1

@onready var game: Node = get_node("/root/Game")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		game.add_score(VALUE)
		queue_free()
