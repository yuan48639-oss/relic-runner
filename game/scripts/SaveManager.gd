extends Node

const SAVE_VERSION = 2
const SAVE_PATH = "user://savegame.json"
const SETTINGS_PATH = "user://settings.json"

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_game(data: Dictionary) -> bool:
	var payload := data.duplicate(true)
	payload["version"] = SAVE_VERSION
	return write_json(SAVE_PATH, payload)

func load_game() -> Dictionary:
	var data := read_json(SAVE_PATH)
	if data.is_empty():
		return {}
	if int(data.get("version", 0)) != SAVE_VERSION:
		return {}
	return data

func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))

func save_settings(data: Dictionary) -> bool:
	var payload := data.duplicate(true)
	payload["version"] = SAVE_VERSION
	return write_json(SETTINGS_PATH, payload)

func load_settings() -> Dictionary:
	var data := read_json(SETTINGS_PATH)
	if data.is_empty():
		return {}
	return data

func write_json(path: String, data: Dictionary) -> bool:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(data, "\t"))
	return true

func read_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var text := file.get_as_text()
	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	return parsed
