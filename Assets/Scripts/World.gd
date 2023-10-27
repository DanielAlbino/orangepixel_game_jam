extends Node2D
@onready var sound = $Ambient_music
var player 
# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Martin
	sound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.deathHost == 3:
		print("You weren't able to save the hostages")
		delta = 0
		return
	if player.hosts == 3:
		print("You Win!! You are the best in business!")
		delta = 0
		return
	if player.hosts + player.deathHost == 3:
		print("You Win, but with some losses")
		delta = 0
		return
	
func save_game():
	pass
