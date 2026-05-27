extends Player
class_name AquaFox

@onready var floor_timer = $Timer
@onready var bubble_factory: Node2DFactory = $Direction/BubbleFactory
@onready var label = $Label
@export var bubble_attack_cooldown: float = 0.8
var check: bool =false
var print_time: float = 5.0
var _bubble_cooldown_timer: float = 0.0

func _update_movement(delta: float) -> void:
	_bubble_cooldown_timer = maxf(_bubble_cooldown_timer - delta, 0.0)

	if (not is_on_floor() and fsm.current_state != fsm.states.swim 
	and fsm.current_state != fsm.states.wateridle 
	and fsm.current_state != fsm.states.float 
	and fsm.current_state != fsm.states.bubbleattack):
		velocity.y += delta * gravity

	var in_water_state = (fsm.current_state == fsm.states.swim 
		or fsm.current_state == fsm.states.wateridle 
		or fsm.current_state == fsm.states.float)

	var on_land_state = (fsm.current_state == fsm.states.idle 
		or fsm.current_state == fsm.states.run 
		or fsm.current_state == fsm.states.jump 
		or fsm.current_state == fsm.states.fall)

	if in_water_state:
		if not floor_timer.is_stopped():
			floor_timer.stop()
		label.visible = false
		check = false

	elif on_land_state:
		if floor_timer.is_stopped() and not check:
			label.visible = true
			floor_timer.start(5.0)

	move_and_slide()



func time_left_to_live():
	var time_left = floor_timer.time_left
	var second = int(time_left)
	return [second]


func _process(delta: float) -> void:
	if fsm.current_state in [fsm.states.swim, fsm.states.wateridle, fsm.states.float]:
		label.visible = false
		return
	# Chỉ update text khi timer đang chạy
	if not floor_timer.is_stopped():
		label.visible = true
		label.text = "%02d" % time_left_to_live()

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
	label.visible = false
	fsm.change_state(fsm.states.dead)
	pass # Replace with function body.
