extends CharacterBody2D

const SPEED = 150.0
const GRAVITY = 1000.0
const PATROL_DISTANCE = 200.0
const MAX_HEALTH = 2

var health = MAX_HEALTH
var direction = 1.0 
var start_position: Vector2

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	start_position = global_position
	sprite.flip_h = direction < 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if is_on_floor():
		velocity.y = 0

	velocity.x = direction * SPEED

	if direction > 0 and global_position.x >= start_position.x + PATROL_DISTANCE:
		direction = -1.0
		sprite.flip_h = true
	elif direction < 0 and global_position.x <= start_position.x - PATROL_DISTANCE:
		direction = 1.0
		sprite.flip_h = false

	move_and_slide()

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()
