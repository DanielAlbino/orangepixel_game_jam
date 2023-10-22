extends StaticBody2D

var speed = 500
var velocity = Vector2(0,0)
var timer
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = 3
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= 0.01
	if timer <= 0:
		queue_free()
	move_and_collide(velocity * speed * delta)
	
	
func _on_area_2d_body_entered(body):
	if((body && !body.is_in_group("bullets") && !body.name.contains("@StaticBody2D")) || timer <= 0):
		queue_free()
