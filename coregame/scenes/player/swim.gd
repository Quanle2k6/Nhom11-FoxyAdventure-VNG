# Swim.gd
extends PlayerState

var swim_speed: float = 150.0
var bobbing_speed: float = 4.0   
var bobbing_amount: float = 5.0 

var idle_water_time: float = 0.0
var time_to_float: float = 3.0 

# Thêm biến đếm thời gian giữ phím cho trục Y
var y_input_timer: float = 0.
var time_to_move_y: float = 0.05 # Thời gian kích hoạt (0.3 giây)

func _enter() -> void:
	obj.change_animation("swim")
	timer = 0.0 
	idle_water_time = 0.0  
	y_input_timer = 0.4 # Reset bộ đếm khi vào nước

func _update(delta: float) -> void:
	var dir_x: float = Input.get_axis('ui_left', 'ui_right')
	var dir_y: float = Input.get_axis('ui_up', 'ui_down')

	if obj.is_on_floor() and not obj.is_in_water:
		change_state(fsm.states.idle)
		return

	if not obj.is_in_water:
		change_state(fsm.states.idle) 
		return

	if abs(dir_x) < 0.1 and abs(dir_y) < 0.1:
		idle_water_time += delta
	else:
		idle_water_time = 0.0
		timer = 0.0 

	#  Logic đếm thời gian cho trục Y 
	if abs(dir_y) > 0.1:
		y_input_timer += delta
	else:
		y_input_timer = 0.0 # Buông phím ra là reset ngay lập tức

	# TRỤC NGANG X
	if abs(dir_x) > 0.1:
		obj.change_direction(sign(dir_x))
		obj.velocity.x = move_toward(obj.velocity.x, dir_x * swim_speed, 20)
	else:
		obj.velocity.x = move_toward(obj.velocity.x, 0, 10)

	# TRỤC DỌC Y
	# Chỉ kích hoạt di chuyển khi đã giữ phím ui_up/ui_down đủ 1 giây
	if abs(dir_y) > 0.1 and y_input_timer >= time_to_move_y:
		obj.velocity.y = move_toward(obj.velocity.y, dir_y * swim_speed, 20)
	else:
		if idle_water_time >= time_to_float:
			timer += delta
			var water_surface_y = get_water_surface_y()
			
			var target_y = water_surface_y - 50
			target_y += sin(timer * bobbing_speed) * bobbing_amount
			
			obj.global_position.y = lerp(obj.global_position.y, target_y, 0.05)
			obj.velocity.y = 0
		else:
			obj.velocity.y = move_toward(obj.velocity.y, 0, 10)

# HÀM PHỤ ĐỂ TÌM MẶT NƯỚC 
func get_water_surface_y() -> float:
	var water_node = obj.get_parent().get_nodes_in_group("WaterGroup").get_node_or_null("Water")
	
	if water_node and water_node.has_node("CollisionShape2D"):
		var shape_node = water_node.get_node("CollisionShape2D")
		var extents_y = shape_node.shape.get_rect().size.y / 2
		return shape_node.global_position.y - extents_y
	return obj.global_position.y
