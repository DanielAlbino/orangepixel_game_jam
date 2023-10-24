extends StaticBody2D

@onready var sound = $"../SFX"
var velocity = Vector2(0,0)
var bullets = 30
const soundPath = preload("res://Assets/Sounds/bullet_pack_drop.mp3")


func _ready():
	sound.set_stream(soundPath)
	sound.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_collide(velocity * delta)

#Verify if the player has enter the area
func _on_area_2d_body_entered(body):
	if (body.name == "Martin"):
		if body.bullets < 100:
			if  body.bullets + bullets >= 100:
				body.bullets = 100
			else:
				body.bullets += bullets
			queue_free()

