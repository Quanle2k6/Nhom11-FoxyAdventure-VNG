extends Player
class_name AquaFox
@onready var water_timer = $Timer
var check: bool =false
var print_time: float = 5.0

@export var bullet_speed: float = 1000.0
@export var fire_rate: float = 1.0

var bullet = preload("res://scenes/player/player_types/Aqua/GunPoint.tscn")
var can_fire: bool = true
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

func _process(delta: float) -> void:
	if Input.is_action_pressed("gun_point") and can_fire:
	
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = $GunPoint.global_position
		bullet_instance.rotation_degrees = rotation_degrees
	
	# Lưu ý: Nếu Bullet là RigidBody2D, apply_impulse trong Godot 4 chỉ cần 1 tham số Vector2 (lực đòn bẩy/vị trí offset đã bị bỏ ở bản 4)
		var impulse = Vector2(bullet_speed, 0).rotated(rotation)
		bullet_instance.apply_impulse(impulse)
	
		get_tree().root.add_child(bullet_instance)
		can_fire = false
	
	# Thay thế hoàn hảo cho yield cũ
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true
	
