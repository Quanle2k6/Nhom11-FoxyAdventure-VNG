extends PlayerState

var dash_timer: float = 0.0
# Called when the node enters the scene tree for the first time.
func _enter() -> void:
	obj.change_animation('jump')
	obj.velocity.x = obj.direction * obj.dash_speed
	dash_timer = obj.dash_duration
	obj.velocity.y = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _update(delta: float) -> void:
	dash_timer -= delta
	if dash_timer >= 0.0 and not obj.is_on_wall():
		obj.velocity.x = obj.direction * obj.dash_speed
	else:
		if obj.is_on_floor() :
			change_state(fsm.states.idle)
		else:
			change_state(fsm.states.fall)
