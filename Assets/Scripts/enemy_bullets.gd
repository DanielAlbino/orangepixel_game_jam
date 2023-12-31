extends StaticBody2D

var velocity = Vector2(0,0)
var timer
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = 3
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= 0.05
	if timer <= 0:
		queue_free()
	move_and_collide(velocity * delta)
	
	
	
func _on_area_2d_body_entered(body):
	if(
		(body && 
		body.name != "enemy_bullets" && 
		body.name != "Jonhy" && 
		!body.name.contains("@StaticBody2D")) || timer <= 0):
		queue_free()
