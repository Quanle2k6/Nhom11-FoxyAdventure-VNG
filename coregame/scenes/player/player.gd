extends BaseCharacter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		fsm = FSM.new(self,$States,$States/Idle)
		super._ready()


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _update_movement(delta: float) -> void:
	if not is_on_floor():
		velocity.y += delta * gravity
	move_and_slide()

	
	
