extends Player
class_name AquaFox

@onready var water_timer = $Timer
@onready var bubble_factory: Node2DFactory = $Direction/BubbleFactory

@export var bubble_attack_cooldown: float = 0.8

var check: bool =false
var print_time: float = 5.0
var _bubble_cooldown_timer: float = 0.0

func _update_movement(delta: float) -> void:
	_bubble_cooldown_timer = maxf(_bubble_cooldown_timer - delta, 0.0)
	# Bỏ qua trọng lực nếu đang ở trạng thái swim
	if not is_on_floor() and fsm.current_state != fsm.states.swim and fsm.current_state != fsm.states.wateridle and fsm.current_state != fsm.states.float and fsm.current_state != fsm.states.bubbleattack :
		velocity.y += delta * gravity
	# Nếu  on_floor đếm ngược time
	if fsm.current_state == fsm.states.idle or fsm.current_state == fsm.states.run  or fsm.current_state == fsm.states.jump or fsm.current_state == fsm.states.fall:
		if water_timer.is_stopped():
			water_timer.start(5.0)
		else:
			if is_on_floor() and not check:
				check = true
				water_timer.stop()
	move_and_slide()

func shoot_bubble(speed: float) -> void:
	var bubble := bubble_factory.create() as BubbleProjectile
	var shooting_direction := Vector2(direction * cos(deg_to_rad(60.0)), -sin(deg_to_rad(60.0)))
	bubble.shoot(shooting_direction, speed)

func can_shoot_bubble() -> bool:
	return fsm.current_state == fsm.states.float and _bubble_cooldown_timer <= 0.0

func change_to_bubble_attack() -> void:
	if not can_shoot_bubble():
		return
	_bubble_cooldown_timer = bubble_attack_cooldown
	fsm.change_state(fsm.states.bubbleattack)


func _on_timer_timeout() -> void:
	if is_on_floor():
		return
