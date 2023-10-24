extends Control

@onready var btn_start = $VBoxContainer/Start
@onready var btn_options = $VBoxContainer/Options
@onready var btn_exit = $VBoxContainer/Exit
@onready var arrow = $VBoxContainer/arrow
@onready var sound = $Menu_Music

func _ready():
	sound.play()
	btn_start.grab_focus()
	arrow.position.y = btn_start.position.y + 35
	
func _input(event):
	if event.is_action_pressed("shoot"):
		var focus_btn = get_viewport().gui_get_focus_owner()
		if focus_btn.name == "Start":
			get_tree().change_scene_to_file("res://Assets/Scenes/World.tscn")
		if focus_btn.name == "Exit":
			get_tree().quit()
		print(focus_btn.name)

func _on_start_pressed():
	if Input.is_action_pressed("shoot"):
		print("pressed button")

		sound.stop()
		get_tree().change_scene_to_file("res://Assets/Scenes/World.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_options_pressed():
	pass # Replace with function body.


func _on_start_focus_entered():
	arrow.position.y = btn_start.position.y + 35
	pass # Replace with function body.


func _on_options_focus_entered():
	arrow.position.y = btn_options.position.y + 35
	pass # Replace with function body.


func _on_exit_focus_entered():
	arrow.position.y = btn_exit.position.y + 35
	pass # Replace with function body.
