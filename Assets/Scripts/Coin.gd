extends StaticBody2D

@onready var spr = $AnimatedSprite2D
var velocity = Vector2(0,0)
var player 
# Called when the node enters the scene tree for the first time.
func _ready():
	spr.play("Rotate")
	player = get_node("World/Martin")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spr.play("Rotate")
	var collision = move_and_collide(velocity * delta)

func _on_area_2d_body_entered(body):
	if (body.name == "Martin"):
		body.coinCount += 1
		queue_free()
