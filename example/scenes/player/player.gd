extends BaseCharacter
var is_in_water: bool = false # Khai báo biến kiểm tra nước
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		fsm = FSM.new(self,$States,$States/Idle)
		super._ready()


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _update_movement(delta: float) -> void:
		# Bỏ qua trọng lực nếu đang ở trạng thái climb, dash HOẶC swim
	if not is_on_floor() and fsm.current_state != fsm.states.climb and fsm.current_state != fsm.states.dash and fsm.current_state != fsm.states.swim:
		velocity.y += delta * gravity	
	move_and_slide()

	# Hai hàm này sẽ được gọi bởi Signal body_entered/exited của Area2D (Vùng nước)
func enter_water() -> void:
	is_in_water = true

func exit_water() -> void:
	is_in_water = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self:
		enter_water()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == self:
		exit_water()
