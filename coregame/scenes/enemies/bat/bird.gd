extends EnemyCharacter

func _ready() -> void:
	fsm = FSM.new(self,$States,$States/Fly)
	super._ready()
	
func _update_movement(delta:float):
	move_and_slide()
