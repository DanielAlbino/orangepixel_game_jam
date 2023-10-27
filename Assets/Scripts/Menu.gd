extends Control

@onready var btn_start = $VBoxContainer/Start
@onready var btn_options = $VBoxContainer/Options
@onready var btn_exit = $VBoxContainer/Exit
@onready var arrow = $VBoxContainer/arrow
@onready var sound = $Menu_Music
@onready var opt = $Options
@onready var video = $VideoStreamPlayer
@onready var masterVolume = $Options/Master_Slider
@onready var musicVolume = $Options/Music_Slider
@onready var sfxVolume = $Options/SFX_Slider

var data = {}

func _ready():
	sound.play()
	btn_start.grab_focus()
	arrow.position.y = btn_start.position.y + 35
	data = getSaveData()
	if data:
		masterVolume.value = data.master_volume
		musicVolume.value = data.music_volume
		sfxVolume.value = data.sfx_volume
		setVolume(data.master_volume, data.music_volume, data.sfx_volume)
	else:
		data = {
			"master_volume" : masterVolume.value,
			"music_volume" : musicVolume.value,
			"sfx_volume" : sfxVolume.value
		}
		setVolume(masterVolume.value, musicVolume.value, sfxVolume.value)
	
func _input(event):
	if event.is_action_pressed("shoot"):
		var focus_btn = get_viewport().gui_get_focus_owner()
		if focus_btn.name == "Start":
			get_tree().change_scene_to_file("res://Assets/Scenes/loading_screen.tscn")
		if focus_btn.name == "Exit":
			get_tree().quit()

func _on_start_pressed():
		sound.stop()
		save(data)
		get_tree().change_scene_to_file("res://Assets/Scenes/loading_screen.tscn")


func _on_exit_pressed():
	getSaveData()
	get_tree().quit()


func _on_options_pressed():
	opt.visible = 	!opt.visible
	btn_start.grab_focus()


func _on_start_focus_entered():
	arrow.position.y = btn_start.position.y + 35


func _on_options_focus_entered():
	arrow.position.y = btn_options.position.y + 35


func _on_exit_focus_entered():
	arrow.position.y = btn_exit.position.y + 35


func _on_back_pressed():
	save(data)
	opt.visible = 	!opt.visible


func _on_video_stream_player_finished():
	video.play()


func _on_master_slider_value_changed(value):
	data.master_volume = value
	data.music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	pass # Replace with function body.


func _on_music_slider_value_changed(value):
	data.music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func _on_sfx_slider_value_changed(value):
	data.sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
	
	
func save(data):
	var file = FileAccess.open("res://Assets/Saves/save.json", FileAccess.WRITE)
	file.store_line(JSON.stringify(data))	
	file.close()
	
func getSaveData():
	var dataFile
	if FileAccess.file_exists("res://Assets/Saves/save.json"):	
		var file = FileAccess.open("res://Assets/Saves/save.json", FileAccess.READ)
		dataFile = JSON.parse_string(file.get_as_text())
		file.close()
		if dataFile is Dictionary:
			return dataFile
		else:
			print("error loading file")
			return
		
	
func setVolume(masterVolume, musicVolume, sfxVolume):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), masterVolume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), musicVolume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfxVolume)
		
		
