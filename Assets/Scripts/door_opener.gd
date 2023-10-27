extends Area2D

var door
var timer = 3
var startTimer
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = 4
	startTimer = false
	door = $"../door"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if startTimer:
		if timer <= 0:
			door.visible = true
			startTimer = false
			for n in 4:
				door.set_collision_layer_value(n, true)
				door.set_collision_mask_value(n, true)
		else:
			timer -= 0.05
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		if door.visible: 
			door.visible = false
			for n in 4:
				door.set_collision_layer_value(n, false)
				door.set_collision_mask_value(n, false)
			startTimer = true
			timer = 10
	pass # Replace with function body.
