extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
var is_attacking = false
var has_hit_this_swing = false

@onready var lv1: Node2D = get_node("/root/Lv1")

const INVULNERABILITY_TIME = 1.5

var is_invulnerable = false
var invulnerability_timer = 0.0

@onready var game: Node = get_node("/root/Game")

func _ready() -> void:
	$Idle.visible = true
	$Walk.visible = false
	$Attack.visible = false
	$Idle.play()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if lv1.cutscene_active:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		return
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		has_hit_this_swing = false
		velocity.x = 0
		$Attack.play()
		$Attack.flip_h = $Idle.flip_h
		$Hitbox.position = $Attack.position
		$Hitbox.set_deferred("monitoring", true)
	
	var direction := Input.get_axis("move_left", "move_right")
	
	if not is_attacking:
		if direction:
			velocity.x = direction * SPEED
			$Walk.play()
			$Walk.flip_h = direction < 0
			$Idle.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	_update_visibility()
	
	move_and_slide()

	if not is_invulnerable:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider.is_in_group("rat"):
				game.lose_life()
				is_invulnerable = true
				invulnerability_timer = INVULNERABILITY_TIME
				velocity = Vector2(collision.get_normal().x * -100.0, -150.0)
				break

	if is_invulnerable:
		invulnerability_timer -= delta
		if invulnerability_timer <= 0:
			is_invulnerable = false
			invulnerability_timer = 0.0

func _update_visibility() -> void:
	if is_attacking:
		$Idle.visible = false
		$Walk.visible = false
		$Attack.visible = true
	elif velocity.x != 0:
		$Idle.visible = false
		$Walk.visible = true
		$Attack.visible = false
	else:
		$Idle.visible = true
		$Walk.visible = false
		$Attack.visible = false
		$Idle.play()

func _on_attack_animation_finished() -> void:
	is_attacking = false
	$Hitbox.monitoring = false
	has_hit_this_swing = false

func _on_hitbox_body_entered(body: Node2D) -> void:
	if is_attacking and not has_hit_this_swing and body.is_in_group("rat"):
		has_hit_this_swing = true
		if body.has_method("take_damage"):
			body.take_damage(1)
		else:
			body.queue_free()
