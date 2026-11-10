extends Node2D

@onready var game: Node = get_node("/root/Game")
@onready var cutscene: CanvasLayer = get_node_or_null("Cutscene")
@onready var cutscene_label: Label = get_node_or_null("Cutscene/CutsceneLabel")
@onready var continue_hint: Label = get_node_or_null("Cutscene/ContinueHint")
var dialogue_shown = false
var goodbye_shown = false
var cutscene_active = false
var cutscene_type = ""
var quit_timer = 0.0

func _ready() -> void:
	if cutscene != null:
		cutscene.visible = false
		show_cutscene("start")

func show_cutscene(type: String) -> void:
	cutscene_type = type
	cutscene_active = true
	quit_timer = 0.0
	if cutscene != null:
		cutscene.visible = true
	if cutscene_label != null:
		cutscene_label.text = ""
	if continue_hint != null:
		continue_hint.text = "\n\n\nPress a key to continue."

	if type == "start":
		if cutscene_label != null:
			cutscene_label.text = "You are Dude. Dude wants as many Coke Zeroes as he can get.\nDude takes his cigs and Coke Zeroes seriously. \nDon't let the rats get to them before you do.\nW to attack\nA to move left \nD to move right\nSpace to jump.\n\nwait\n\nwhat's that at the end?"
	elif type == "end":
		if game.is_game_over():
			if cutscene_label != null:
				cutscene_label.text = "your mind\nwon\nFinal Score: %d" % game.score
		else:
			if cutscene_label != null:
				cutscene_label.text = "are you sure\n that's the end\n\nGreat job. This will get Dude through breakfast.\nFinal Score: %d" % game.score

func hide_cutscene() -> void:
	cutscene_active = false
	if cutscene != null:
		cutscene.visible = false

	if cutscene_type == "end":
		quit_timer = 5.0
	else:
		if cutscene_type == "end":
			get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
	if cutscene_active and event is InputEventKey and event.pressed:
		hide_cutscene()

func _process(delta: float) -> void:
	if cutscene_active:
		return
	if game.is_game_over():
		show_cutscene("end")
		return

	var pickups = get_tree().get_nodes_in_group("pickup")
	if pickups.size() == 0:
		show_cutscene("end")

	if not cutscene_active and not game.is_game_over():
		if pickups.size() == 0:
			show_cutscene("end")


func _on_oh_no_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not dialogue_shown:
		dialogue_shown = true
		cutscene_active = true
		if cutscene != null:
			cutscene.visible = true
		if cutscene_label != null:
			cutscene_label.text = "..something is off"
		if continue_hint != null:
			continue_hint.text = "..do you want to continue?"
		


func _on_goodbye_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not dialogue_shown:
		goodbye_shown = true
		cutscene_active = true
		if cutscene != null:
			cutscene.visible = true
		if cutscene_label != null:
			cutscene_label.text = "you can't escape this"
		if continue_hint != null:
			continue_hint.text = "see\nyou\nsoon\n\ngoodbye"
