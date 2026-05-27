extends PlayerState

@export var bubble_speed: float = 420.0
@export var attack_duration: float = 0.2

func _enter() -> void:
	obj.change_animation("idle")
	obj.shoot_bubble(bubble_speed)
	await get_tree().create_timer(attack_duration).timeout
	if fsm.current_state == self:
		obj.mark_attack_completed()
		if obj.is_in_water >= 1:
			change_state(fsm.states.float)
		elif obj.is_on_floor():
			change_state(fsm.states.idle)
		else:
			change_state(fsm.states.fall)

func _update(_delta: float) -> void:
	obj.position.y = obj.water_surface_y
	obj.velocity.y = 0
	control_moving()
