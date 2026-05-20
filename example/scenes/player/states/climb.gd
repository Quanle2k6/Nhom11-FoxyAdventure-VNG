extends PlayerState


# Called when the node enters the scene tree for the first time.
func _enter() -> void:
	obj.change_animation('jump')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _update(delta: float) -> void:
	control_water()
	control_jump()
	control_dash()
	if not obj.is_on_wall_only() or Input.is_action_just_released("right") or Input.is_action_just_released("left"):
		change_state(fsm.states.fall)
