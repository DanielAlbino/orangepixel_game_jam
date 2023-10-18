extends StaticBody2D
@onready var spr = $AnimatedSprite2D
var life = 35
const coinPath = preload("res://Assets/Prefabs/coin.tscn")

func _process(delta):
	if life <= 0:
		spr.play("explode")
		if spr.get_frame() == 7:
			initializeCoin()
	move_and_collide(Vector2(0,0))

func initializeCoin():
	var coin = coinPath.instantiate()
	get_parent().add_child(coin)
	var _position = self.global_position
	coin.position = _position
	removeObject()


func removeObject():
	queue_free()


func _on_detect_bullets_body_entered(body):
	if(body.name == "Bullets"):
		life -=15
