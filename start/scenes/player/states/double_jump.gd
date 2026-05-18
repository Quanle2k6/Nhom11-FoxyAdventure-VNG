extends PlayerState


# Called when the node enters the scene tree for the first time.
func _enter() -> void:
	obj.change_animation('jump')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _update(delta: float) -> void:
	control_dash()
	control_moving()
	control_climb()
	if obj.velocity.y > 0:
		change_state(fsm.states.fall)
