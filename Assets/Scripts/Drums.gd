extends StaticBody2D
@onready var spr = $AnimatedSprite2D
@onready var sound = $"../SFX_Explosions"
var life = 35
var path
func _ready():
	sound.volume_db = -10

func _process(_delta):
	
	if life <= 0:
		spr.play("explode")
		if spr.get_frame() == 0:
			sound.play()
		if spr.get_frame() == 7:
			initializeCoin()
	move_and_collide(Vector2(0,0))

func initializeCoin():
	var id = randi_range(0,2)
	if id == 0:
		path = preload("res://Assets/Prefabs/coin.tscn")
	if id == 1:
		path = preload("res://Assets/Prefabs/health_box.tscn")
	if id == 2:
		path = preload("res://Assets/Prefabs/bullets_pack.tscn")
	var item = path.instantiate()
	get_parent().add_child(item)
	var _position = self.global_position
	item.position = _position
	removeObject()


func removeObject():
	queue_free()


func _on_detect_bullets_body_entered(body):
	if body.is_in_group("bullets") || body.is_in_group("enemy_bullets"):
		life -=15
	if life <= 0:
		if body.is_in_group("player"):
			if body.health - 15 <= 0:
				body.health = 0
			else:
				body.health -= 10
				body.light.color =  Color(255, 0, 0, 0.003)
				body.lightTimer = 0.03
		if body.is_in_group("enemy") || body.is_in_group("robots"):
			if body.life - 15 <= 0:
				body.life = 0
			else:
				body.life -= 15
				if body.light:
					body.light.color =  Color(255, 0, 0, 0.003)
					body.lightTimer = 0.03
			
