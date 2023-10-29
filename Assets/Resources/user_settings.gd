class_name UserSettings extends Resource

@export_range(-28,10,2) var master_volume: int = 5
@export_range(-28,10,2) var music_volume: int = 5
@export_range(-28,10,2) var sfx_volume: int = 5
@export var current_level: String = ''
@export var gameover_text: String = ''


func save() -> void:
	ResourceSaver.save(self, "user://user_settings.tres")


static func load_or_create() -> UserSettings:
	var res: UserSettings = load("user://user_settings.tres") as UserSettings
	if !res:
		res = UserSettings.new()
	return res
