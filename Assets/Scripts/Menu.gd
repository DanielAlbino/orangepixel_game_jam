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

func _on_start_pressed():
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
