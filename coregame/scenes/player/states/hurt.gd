extends PlayerState

@export var land_hurt_duration: float = 0.5
@export var water_hurt_duration: float = 0.3
@export var land_knockback_speed: float = 120.0
@export var land_knockback_up_speed: float = 160.0
@export var water_knockback_speed: float = 80.0
@export var water_knockback_vertical_speed: float = 35.0
@export var water_damping: float = 700.0

var _is_water_hurt: bool = false

func _enter() -> void:
	obj.is_invulnerable = true
	_is_water_hurt = obj.is_in_water >= 1
	var knockback_dir := _get_knockback_direction()
	if _is_water_hurt:
		obj.velocity.x = knockback_dir * water_knockback_speed
		obj.velocity.y = clampf(obj.last_hurt_direction.y * water_knockback_vertical_speed, -water_knockback_vertical_speed, water_knockback_vertical_speed)
		timer = water_hurt_duration
	else:
		obj.velocity.x = knockback_dir * land_knockback_speed
		obj.velocity.y = -land_knockback_up_speed
		timer = land_hurt_duration
	if obj.animated_sprite != null and obj.animated_sprite.sprite_frames.has_animation("hurt"):
		obj.change_animation("hurt")
	elif obj.animated_sprite != null and obj.animated_sprite.sprite_frames.has_animation("fall"):
		obj.change_animation("fall")

func _update(delta: float) -> void:
	if _is_water_hurt:
		_update_water_hurt(delta)
	if update_timer(delta):
		obj.is_invulnerable = false
		if obj.is_in_water >= 1:
			if obj.global_position.y <= obj.water_surface_y:
				obj.global_position.y = obj.water_surface_y
				obj.velocity.y = 0
				change_state(fsm.states.float)
			else:
				change_state(fsm.states.wateridle)
		elif obj.is_on_floor():
			change_state(fsm.states.idle)
		else:
			change_state(fsm.states.fall)

func _exit() -> void:
	if _is_water_hurt:
		obj.velocity.x = move_toward(obj.velocity.x, 0.0, water_damping * get_physics_process_delta_time())
		obj.velocity.y = move_toward(obj.velocity.y, 0.0, water_damping * get_physics_process_delta_time())

func _update_water_hurt(delta: float) -> void:
	obj.velocity.x = move_toward(obj.velocity.x, 0.0, water_damping * delta)
	obj.velocity.y = move_toward(obj.velocity.y, 0.0, water_damping * delta)
	if obj.is_in_water >= 1 and obj.global_position.y <= obj.water_surface_y:
		obj.global_position.y = obj.water_surface_y
		obj.velocity.y = maxf(obj.velocity.y, 0.0)

func _get_knockback_direction() -> float:
	if absf(obj.last_hurt_direction.x) > 0.1:
		return sign(obj.last_hurt_direction.x)
	return -obj.direction
