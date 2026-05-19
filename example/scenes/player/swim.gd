# Swim.gd
extends PlayerState

var swim_speed: float = 150.0
var bobbing_speed: float = 4.0   
var bobbing_amount: float = 15.0 

func _enter() -> void:
	obj.change_animation("swim")
	timer = 0.0 

func _update(delta: float) -> void:
	# --- SỬA LỖI BƯỚC LÊN BỜ Ở ĐÂY ---
	# Nếu chân đã chạm đất vững chắc, thoát State bơi ngay lập tức
	if obj.is_on_floor():
		change_state(fsm.states.idle)
		return

	# Nếu hoàn toàn thoát khỏi vùng nước
	if not obj.is_in_water:
		change_state(fsm.states.idle) 
		return

	timer += delta

	# 1. Lấy input từ người chơi
	var dir_x: float = Input.get_axis('left', 'right')
	var dir_y: float = Input.get_axis('ui_up', 'ui_down')
	
	# --- TRỤC NGANG (X) ---
	if abs(dir_x) > 0.1:
		obj.change_direction(sign(dir_x))
		obj.velocity.x = move_toward(obj.velocity.x, dir_x * swim_speed, 20)
	else:
		obj.velocity.x = move_toward(obj.velocity.x, 0, 10) 

	# --- TRỤC DỌC (Y) ---
	if abs(dir_y) > 0.1:
		obj.velocity.y = move_toward(obj.velocity.y, dir_y * swim_speed, 20)
	else:
		# Hiệu ứng lềnh bềnh
		var float_pattern = sin(timer * bobbing_speed) * bobbing_amount
		obj.velocity.y = move_toward(obj.velocity.y, float_pattern, 10)
