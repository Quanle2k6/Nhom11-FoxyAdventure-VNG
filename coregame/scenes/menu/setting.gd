extends Node

# Khai báo signal gửi kèm trạng thái: true (mở), false (đóng)
signal settings_toggled(is_open: bool)

@onready var canvas = $CanvasLayer
@onready var slider_music = $CanvasLayer/setting_panel/Music
@onready var slider_sfx = $CanvasLayer/setting_panel/SFX

func _ready() -> void:
	canvas.visible = false
	slider_music.value = AudioSetting.get_music_volume()
	slider_sfx.value = AudioSetting.get_sfx_volume()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu_settings"):
		toggle()

func toggle() -> void:
	if canvas.visible:
		close_settings()
	else:
		open_settings()

func open_settings() -> void:
	canvas.visible = true
	get_tree().paused = true 
	settings_toggled.emit(true) # Bắn tín hiệu: "Tôi đang mở"

func close_settings() -> void:
	canvas.visible = false
	get_tree().paused = false
	settings_toggled.emit(false) # Bắn tín hiệu: "Tôi đã đóng"

func _on_music_value_changed(value: float) -> void:
	AudioSetting.set_music_volume(value)

func _on_sfx_value_changed(value: float) -> void:
	AudioSetting.set_sfx_volume(value)

func _on_close_pressed() -> void:
	close_settings()


func _on_open_setting_pressed() -> void:
	close_settings()
