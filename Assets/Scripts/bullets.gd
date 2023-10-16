extends StaticBody2D

var speed = 500
var velocity = Vector2(0,0)
var timer
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = 3
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_collide(velocity * speed * delta)
	timer -= 0.05
	
func _on_area_2d_body_entered(body):
	if((body && body.name != "Bullets" && !body.name.contains("@StaticBody2D")) || timer == 0):
		queue_free()
