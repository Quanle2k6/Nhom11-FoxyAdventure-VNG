class_name BubbleProjectile
extends RigidBody2D

@onready var hit_area: HitArea2D = $HitArea2D

func _ready() -> void:
	hit_area.hitted.connect(_on_hit_area_hitted)
	$AnimatedSprite2D.play()

func shoot(shooting_direction: Vector2, speed: float) -> void:
	var normalized_direction := shooting_direction.normalized()
	rotation = normalized_direction.angle()
	apply_impulse(normalized_direction * speed)

func _physics_process(_delta: float) -> void:
	if linear_velocity.length_squared() > 0.01:
		rotation = linear_velocity.angle()

func _on_hit_area_hitted(_area: Area2D) -> void:
	queue_free()

func _on_body_entered(_body: Node) -> void:
	queue_free()
