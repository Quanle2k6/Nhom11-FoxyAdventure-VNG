class_name ClawProjectile
extends RigidBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play()

func shoot(shooting_direction: Vector2, speed: float) -> void:
	var normalized_direction := shooting_direction.normalized()
	rotation = normalized_direction.angle()
	animated_sprite.flip_v = normalized_direction.x < 0
	apply_impulse(normalized_direction * speed)
