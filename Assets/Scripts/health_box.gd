extends StaticBody2D

@onready var spr = $AnimatedSprite2D
var velocity = Vector2(0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(velocity * delta)

#Verify if the player has enter the area
func _on_area_2d_body_entered(body):
	if (body.name == "Martin"):
		body.health += 10
		queue_free()
