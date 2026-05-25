extends Player
class_name AquaFox
@onready var water_timer = $Timer
var check: bool =false
var print_time: float = 5.0
func _update_movement(delta: float) -> void:
	# Bỏ qua trọng lực nếu đang ở trạng thái swim
	if not is_on_floor() and fsm.current_state != fsm.states.swim and fsm.current_state != fsm.states.wateridle and fsm.current_state != fsm.states.float :
		velocity.y += delta * gravity
	# Nếu  on_floor đếm ngược time
	if fsm.current_state == fsm.states.idle or fsm.current_state == fsm.states.run or fsm.current_state == fsm.states.jump or fsm.current_state == fsm.states.fall:
		if water_timer.is_stopped():
			water_timer.start(5.0)
		else:
			if is_on_floor() and not check:
				check = true
				water_timer.stop()
	move_and_slide()


func _on_timer_timeout() -> void:
	if is_on_floor():
		respawn()
