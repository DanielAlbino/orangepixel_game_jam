extends StaticBody2D

@onready var spr = $AnimatedSprite2D
var velocity = Vector2(0,0)
var health = 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_collide(velocity * delta)

#Verify if the player has enter the area
func _on_area_2d_body_entered(body):
	if (body.name == "Martin"):
		if body.health < 100:
			if body.health + health >= 100:
				body.health = 100
			else:
				body.health += health
			queue_free()
