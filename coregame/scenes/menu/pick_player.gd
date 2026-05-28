extends Control

const OPTIONS := [
	{
		"root_path": "Normal",
		"button_path": "Normal/NormalFox",
		"selection_path": "Normal/NormalSelection",
		"scene": preload("res://scenes/player/player_types/normal/normal.tscn"),
		"key": GameManager.NORMAL_FOX,
	},
	{
		"root_path": "Aqua",
		"button_path": "Aqua/AquaFox",
		"selection_path": "Aqua/AquaSelection",
		"scene": preload("res://scenes/player/player_types/aqua/aqua.tscn"),
		"key": GameManager.AQUA_FOX,
	},
	{
		"root_path": "Jungle",
		"button_path": "Jungle/JungleFox",
		"selection_path": "Jungle/JungleSelection",
		"scene": preload("res://scenes/player/player_types/jungle/jungle.tscn"),
		"key": GameManager.JUNGLE_FOX,
	},
]

@onready var reset_hint: Label = $ResetHint

var selected_index: int = 0

func _ready() -> void:
	selected_index = get_first_unlocked_index()
	AudioManager.stop_music()
	update_selection()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		move_selection(-1)
	elif event.is_action_pressed("right"):
		move_selection(1)
	elif event.is_action_pressed("ui_accept"):
		select_current_player()
	elif event.is_action_pressed("reset"):
		reset_current_checkpoint()

func move_selection(step: int) -> void:
	for offset in range(1, OPTIONS.size() + 1):
		var next_index := wrapi(selected_index + step * offset, 0, OPTIONS.size())
		if is_option_unlocked(next_index):
			selected_index = next_index
			update_selection()
			return

func update_selection() -> void:
	for index in OPTIONS.size():
		var is_unlocked := is_option_unlocked(index)
		var root := get_node(OPTIONS[index]["root_path"]) as CanvasItem
		var button := get_node(OPTIONS[index]["button_path"]) as TextureButton
		var selection := get_node(OPTIONS[index]["selection_path"]) as Label
		root.modulate = Color(1, 1, 1, 1) if is_unlocked else Color(1, 1, 1, 0.35)
		button.disabled = not is_unlocked
		selection.visible = is_unlocked and index == selected_index
	reset_hint.text = "R: Reset checkpoint"

func get_first_unlocked_index() -> int:
	for index in OPTIONS.size():
		if is_option_unlocked(index):
			return index
	return 0

func is_option_unlocked(index: int) -> bool:
	return GameManager.is_player_unlocked(OPTIONS[index]["key"])

func select_current_player() -> void:
	if not is_option_unlocked(selected_index):
		return
	GameManager.select_player(OPTIONS[selected_index]["key"], OPTIONS[selected_index]["scene"])
	GameManager.change_to_main_map()

func reset_current_checkpoint() -> void:
	GameManager.clear_checkpoint(OPTIONS[selected_index]["key"])

func _on_normal_fox_pressed() -> void:
	selected_index = 0
	select_current_player()

func _on_aqua_fox_pressed() -> void:
	selected_index = 1
	select_current_player()

func _on_jungle_fox_pressed() -> void:
	selected_index = 2
	select_current_player()
