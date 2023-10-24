extends CharacterBody2D

var life = 3
var isFollowingPlayer = false
@onready var light = $PointLight2D

func _physics_process(_delta):
	if isFollowingPlayer:
		followPlayer()
	pass

func followPlayer():
	print("Will follow player")
	pass

func _on_area_2d_body_entered(body):
	print(body.name)
	if body.is_in_group("player"):
		isFollowingPlayer = true
	if body.is_in_group("bullets") || body.is_in_group("enemy_bullets"):
		if life > 0:
			life -= 1
		else:
			queue_free()
