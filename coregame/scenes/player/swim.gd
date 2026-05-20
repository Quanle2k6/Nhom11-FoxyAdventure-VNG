# Swim.gd
extends PlayerState

var swim_speed: float = 150.0
var bobbing_speed: float = 4.0   
var bobbing_amount: float = 5.0 # Giảm bớt biên độ dập dềnh để trông mịn hơn ở mặt nước

var idle_water_time: float = 0.0
var time_to_float: float = 3.0 

func _enter() -> void:
	obj.change_animation("swim")
	timer = 0.0 
	idle_water_time = 0.0 

func _update(delta: float) -> void:
	if obj.is_on_floor():
		change_state(fsm.states.idle)
		return

	if not obj.is_in_water:
		change_state(fsm.states.idle) 
		return

	# 1. Lấy input từ người chơi
	var dir_x: float = Input.get_axis('left', 'right')
	var dir_y: float = Input.get_axis('ui_up', 'ui_down')
	
	# Kiểm tra xem người chơi có đang thả tay không
	if abs(dir_x) < 0.1 and abs(dir_y) < 0.1:
		idle_water_time += delta
	else:
		idle_water_time = 0.0
		timer = 0.0 

	# --- TRỤC NGANG (X) ---
	if abs(dir_x) > 0.1:
		obj.change_direction(sign(dir_x))
		obj.velocity.x = move_toward(obj.velocity.x, dir_x * swim_speed, 20)
	else:
		box_drag_x() # Hàm phụ giúp giảm tốc mượt mà

	# --- TRỤC DỌC (Y) ---
	if abs(dir_y) > 0.1:
		obj.velocity.y = move_toward(obj.velocity.y, dir_y * swim_speed, 20)
	else:
		# KHI THẢ TAY:
		if idle_water_time >= time_to_float:
			# ĐÃ QUÁ 3 GIÂY -> KÍCH HOẠT NỔI LÊN MẶT NƯỚC VÀ LỀNH BỀNH
			timer += delta
			
			# Lấy vị trí đỉnh (mặt nước) của vùng Area2D hiện tại
			var water_surface_y = get_water_surface_y() 
			
			# ĐỊNH VỊ NỬA THÂN:
			# Chúng ta muốn tâm của nhân vật (global_position.y) nằm thấp hơn mặt nước một chút.
			# Ví dụ: Nếu nhân vật cao 32 pixel, ta muốn họ chìm 16 pixel dưới nước (nửa thân).
			# Bạn chỉnh con số '16.0' này tùy theo chiều cao Sprite của bạn nhé!
			var target_y = water_surface_y - 100
			
			# Thêm hiệu ứng dập dềnh sóng nước vào vị trí đích
			target_y += sin(timer * bobbing_speed) * bobbing_amount
			
			# Di chuyển mượt mà vị trí (global_position) của nhân vật tới vị trí đích nửa thân này
			obj.global_position.y = lerp(obj.global_position.y, target_y, 0.05)
			
			# Triệt tiêu vận tốc Y để không bị trọng lực hay lực khác kéo giật
			obj.velocity.y = 0
		else:
			# Chưa đủ 3 giây -> Đứng yên lơ lửng tại chỗ
			obj.velocity.y = move_toward(obj.velocity.y, 0, 10)

func box_drag_x() -> void:
	obj.velocity.x = move_toward(obj.velocity.x, 0, 10)

# --- HÀM PHỤ ĐỂ TÌM MẶT NƯỚC ---
func get_water_surface_y() -> float:
	# Tìm node WaterArea trong Scene thông qua tên (hoặc group tùy bạn setup)
	# Ở đây vùng nước của bạn ở Scene Level tên là "Water"
	var water_area = obj.get_parent().get_node_or_null("Water")
	
	if water_area and water_area.has_node("CollisionShape2D"):
		var shape_node = water_area.get_node("CollisionShape2D")
		var extents_y = shape_node.shape.get_rect().size.y / 2
		# Vị trí mặt nước = Vị trí tâm của Area2D trừ đi một nửa chiều cao của nó
		return shape_node.global_position.y - extents_y
		
	# Nếu không tìm thấy, trả về vị trí hiện tại của player làm mốc an toàn
	return obj.global_position.y
