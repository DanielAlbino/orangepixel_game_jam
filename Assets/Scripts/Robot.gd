extends CharacterBody2D
@onready var spr = $AnimatedSprite2D
@onready var lifeBar = $TextureProgressBar
@onready var light = $PointLight2D
@onready var sound = $"../SFX_Explosions"
const speed = 100
var isAttacking = false
var timer
var choosenMove
var life = 50
const coinPath = preload("res://Assets/Prefabs/coin.tscn")

func _ready():
	lifeBar.max_value = life
	timer = 5
	choosenMove = randi_range(0,4)

func _physics_process(delta):
	if life > 0:
		if spr.flip_h:
			light.position.x = -3
		else:
			light.position.x = 3
			
		lifeBar.value = life
		if !isAttacking:
			if timer <= 0:
				timer = randi_range(3,5)
				choosenMove = randi_range(0,4)
			else:
				timer -= 0.05
				handleBasicMovement(choosenMove)
		var collisions = move_and_collide(velocity*delta)
		if collisions != null:
			timer = randi_range(3,5)
			choosenMove = randi_range(0,4)
	else:
		lifeBar.value = 0
		velocity.x = 0
		velocity.y = 0
		explode()
		
	
		
		
func initializeCoin():
	var coin = coinPath.instantiate()
	get_parent().add_child(coin)
	var _position = self.global_position
	coin.position = _position
	removeObject()
	
func removeObject():
	queue_free()
	
	# ['idle','move_up', 'move_down', 'move_left', 'move_right']
func handleBasicMovement(move):
	# Idle Enemy
	if move == 0:
		spr.play('Idle')
		velocity.x = 0
		velocity.y = 0
		
	# Enemy move up
	if move == 1:
		spr.play('Run')
		velocity.x = 0
		velocity.y = -speed
	
	# Enemy move down
	if move == 2:
		spr.play('Run')
		velocity.x = 0
		velocity.y = speed
		
	# Enemy move Left
	if move == 3:
		spr.play('Run')
		spr.flip_h = true
		velocity.x = -speed
		velocity.y = 0
	
	# Enemy move down
	if move == 4:
		spr.play('Run')
		spr.flip_h = false
		velocity.x = speed
		velocity.y = 0
	

func _on_detect_bullets_body_entered(body):
	if(body.is_in_group("bullets")):
		life -= 15
		spr.play("Hit")
		velocity.x = 0
		velocity.y = 0
		timer = 0
	
			
func explode():
	spr.play("Exploding")
	if spr.get_frame() == 0:
		sound.play()
	if spr.get_frame() == 7:
		initializeCoin()	


func _on_detect_player_body_entered(body):
	if(body.is_in_group("player")):
		if body.health - 25 <= 0:
			body.health = 0
		else:
			body.health -= 25
		life = 0
