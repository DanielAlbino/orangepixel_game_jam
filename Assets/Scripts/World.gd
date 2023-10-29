extends Node2D
@onready var sound = $Ambient_music
var player 
var user_settings: UserSettings
# Called when the node enters the scene tree for the first time.
func _ready():
	user_settings = UserSettings.load_or_create()
	player = $Martin
	sound.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.deathHost == 3:
		user_settings.gameover_text = "Game Over! \nYou didn't save the hostages"
		user_settings.save()
		showGameoverScene()
	if player.hosts == 3:
		user_settings.gameover_text = "You Win!! \nYou are the best in business!"
		user_settings.save()
		showGameoverScene()
	if  player.deathHost > 0 && player.hosts + player.deathHost == 3:
		user_settings.gameover_text = "You Win! \nHowever you had some losses."
		user_settings.save()
		showGameoverScene()
	if player.health <= 0:
		user_settings.gameover_text = "Game Over \nYou have died. More luck next time."
		user_settings.save()
		showGameoverScene()
	
func showGameoverScene():
	get_tree().change_scene_to_file("res://Assets/Scenes/game_over.tscn")	



