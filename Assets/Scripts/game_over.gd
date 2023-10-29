extends Node2D
var user_settings: UserSettings
# Called when the node enters the scene tree for the first time.
func _ready():
	user_settings = UserSettings.load_or_create()
	$Panel/Label.text = user_settings.gameover_text

func _on_restart_pressed():
	var level = user_settings.current_level
	get_tree().change_scene_to_file("res://Assets/Scenes/"+level+".tscn")

func _on_exit_pressed():
	get_tree().quit()

func _on_new_level_pressed():
	get_tree().change_scene_to_file("res://Assets/Scenes/loading_screen.tscn")
