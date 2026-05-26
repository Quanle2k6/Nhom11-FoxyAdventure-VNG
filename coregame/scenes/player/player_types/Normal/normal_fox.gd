extends Player
class_name  NormalFox
@onready var water_timer = $Timer

func _update_movement(delta: float) -> void:
	
	# Bỏ qua trọng lực nếu đang ở trạng thái swim
	if not is_on_floor() and fsm.current_state != fsm.states.swim and fsm.current_state != fsm.states.wateridle and fsm.current_state != fsm.states.float:
		velocity.y += delta * gravity
	if is_in_water >=1:
		# Nếu đang ở dưới nước mà Timer CHƯA CHẠY, thì mới kích hoạt cho nó chạy
		if water_timer.is_stopped():
			water_timer.start(5.0) # Bắt đầu đếm ngược từ 5 giây
	else:
		# Nếu nhân vật đã lên cạn (không còn bơi nữa), lập tức DỪNG TIMER LẠI
		# Đây chính là hành động "reset time" để lần sau rơi xuống nước nó đếm lại từ đầu
		water_timer.stop()
	move_and_slide()

func _on_timer_timeout() -> void:
	respawn()
	AudioManager.play_sound("player_die")
	pass # Replace with function body.

func can_attack() -> bool:
	return true
