extends Node

@onready var video = $VideoStreamPlayer
@onready var btn_start = $VBoxContainer/Start
@onready var btn_options = $VBoxContainer/Options
@onready var btn_exit = $VBoxContainer/Exit
@onready var arrow = $VBoxContainer/arrow
@onready var sound = $Menu_Music
@onready var opt = $Options
@onready var masterVolume = $Options/Master_Slider
@onready var musicVolume = $Options/Music_Slider
@onready var sfxVolume = $Options/SFX_Slider

var user_settings: UserSettings

func _on_ready():
	video.play()
	sound.play()
	btn_start.grab_focus()
	arrow.position.y = btn_start.position.y + 35
	user_settings = UserSettings.load_or_create()
	masterVolume.value = user_settings.master_volume
	musicVolume.value = user_settings.music_volume
	sfxVolume.value = user_settings.sfx_volume


func _on_start_pressed():
	if Input.is_action_pressed("shoot"):
		sound.stop()
		user_settings.current_level = 'none'
		user_settings.gameover_text = ''
		user_settings.save()
		get_tree().change_scene_to_file("res://Assets/Scenes/loading_screen.tscn")

func _on_exit_pressed():
	user_settings.save()
	get_tree().quit()

func _on_start_focus_entered():
	arrow.position.y = btn_start.position.y + 35


func _on_options_focus_entered():
	arrow.position.y = btn_options.position.y + 35


func _on_exit_focus_entered():
	arrow.position.y = btn_exit.position.y + 35


func _on_back_pressed():
	opt.visible = 	!opt.visible


func _on_video_stream_player_finished():
	video.play()


func _on_master_slider_value_changed(value):
	user_settings.master_volume = value
	user_settings.music_volume = value
	user_settings.sfx_volume = value
	masterVolume.value = value
	musicVolume.value = value
	sfxVolume.value = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
	pass # Replace with function body.


func _on_music_slider_value_changed(value):
	if masterVolume.value > value:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
		user_settings.music_volume = value
		

func _on_sfx_slider_value_changed(value):
	if masterVolume.value > value:
		user_settings.sfx_volume = value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
		$Options/sfx.volume_db = value
		$Options/sfx.play()
		
	
func setVolume(_masterVolume, _musicVolume, _sfxVolume):
	$Options/sfx.volume_db = _sfxVolume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), _masterVolume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), _musicVolume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), _sfxVolume)
		
		
func _on_start_mouse_entered():
	btn_start.grab_focus()

func _on_options_mouse_entered():
	btn_options.grab_focus()

func _on_exit_mouse_entered():
	btn_exit.grab_focus()

func _on_options_pressed():
	opt.visible = !opt.visible
