extends Player
class_name  NormalFox
@onready var water_timer = $Timer
@onready var label = $Label
func _update_movement(delta: float) -> void:
	
	# Bỏ qua trọng lực nếu đang ở trạng thái swim
	if not is_on_floor() and fsm.current_state != fsm.states.swim and fsm.current_state != fsm.states.wateridle and fsm.current_state != fsm.states.float:
		velocity.y += delta * gravity

	if fsm.current_state == fsm.states.swim or fsm.current_state == fsm.states.wateridle:
		# Đang swim/wateridle → bắt đầu đếm nếu chưa chạy
		if water_timer.is_stopped():
			water_timer.start(5.0)
	elif is_on_floor() or fsm.current_state == fsm.states.float:
		# Trên đất hoặc float → dừng timer
		water_timer.stop()

	move_and_slide()

func time_left_to_live():
	var time_left = water_timer.time_left
	var second = int(time_left)
	return [second+1]


func _process(delta: float) -> void:
	if is_on_floor() or fsm.current_state == fsm.states.float or fsm.current_state == fsm.states.dead or fsm.current_state == fsm.states.fall:
		label.visible = false
		return
	if not water_timer.is_stopped():
		label.visible = true
		label.text = "%02d" % time_left_to_live()

func _on_timer_timeout() -> void:
	fsm.change_state(fsm.states.dead)
	pass # Replace with function body.

func can_attack() -> bool:
	return true

func skill():
	print("Normal Fox")
