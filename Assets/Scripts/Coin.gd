extends StaticBody2D

@onready var spr = $AnimatedSprite2D
var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	spr.play("Rotate")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spr.play("Rotate")
	move_and_collide(velocity * delta)

#Verify if the player has enter the area
func _on_area_2d_body_entered(body):
	if (body.name == "Martin"):
		body.coinCount += 1
		queue_free()
