extends Node2D

var percent = 0
@onready var bar = $Control/TextureProgressBar
var data
const levels =['World','World2','World3']
var user_settings: UserSettings
# Called when the node enters the scene tree for the first time.
func _ready():
	user_settings = UserSettings.load_or_create()
	percent = 0
	bar.value = percent
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(percent < 100):
		percent += 0.5
		bar.value = percent
	else:
		var level = randi_range(0,2)
		if !user_settings.current_level || levels[level] != user_settings.current_level:
			user_settings.current_level = levels[level]
			if level == 0:
				get_tree().change_scene_to_file("res://Assets/Scenes/World.tscn")
			if level == 1:
				get_tree().change_scene_to_file("res://Assets/Scenes/World2.tscn")
			if level == 2:
				get_tree().change_scene_to_file("res://Assets/Scenes/World3.tscn")
			user_settings.save()
