extends StaticBody2D

@onready var spr = $AnimatedSprite2D
var velocity = Vector2(0,0)
var bullets = 30

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_collide(velocity * delta)

#Verify if the player has enter the area
func _on_area_2d_body_entered(body):
	if (body.name == "Martin"):
		if  body.bullets + bullets >= 100:
			body.bullets = 100
		else:
			body.bullets += bullets
		queue_free()

