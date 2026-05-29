extends Node

const SAVE_PATH = "user://audio_settings.cfg"

func _ready() -> void:
	load_settings()
	process_mode = Node.PROCESS_MODE_ALWAYS

func set_music_volume(value: float) -> void:
	AudioManager.set_bus_volume("Music", linear_to_db(value / 100.0))
	_save("music", value)

func set_sfx_volume(value: float) -> void:
	AudioManager.set_bus_volume("SFX", linear_to_db(value / 100.0))
	_save("sfx", value)

func get_music_volume() -> float:
	return _load("music")

func get_sfx_volume() -> float:
	return _load("sfx")

func _save(key: String, value: float) -> void:
	var config = ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("audio", key, value)
	config.save(SAVE_PATH)

func _load(key: String) -> float:
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		return config.get_value("audio", key, 100.0)
	return 100.0

func load_settings() -> void:
	set_music_volume(get_music_volume())
	set_sfx_volume(get_sfx_volume())
