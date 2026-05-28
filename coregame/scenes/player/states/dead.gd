extends PlayerState

@export var return_delay: float = 2.0
@export var player_select_menu_path: String = "res://scenes/menu/pick_player.tscn"

func _enter() -> void:
	obj.stop_move()
	obj.is_invulnerable = true
	obj.is_in_water = 0
	if obj.animated_sprite != null and obj.animated_sprite.sprite_frames.has_animation("dead"):
		obj.change_animation("dead")
	timer = return_delay
	AudioManager.stop_music(0.5)

func _update(delta: float) -> void:
	obj.stop_move()
	if update_timer(delta):
		GameManager.change_to_scene(player_select_menu_path)
