extends CharacterBody2D
@onready var spr = $AnimatedSprite2D
const speed = 100
var isAttacking = false
var timer
var choosenMove
var life = 50

const coinPath = preload("res://Assets/Prefabs/coin.tscn")
func _ready():
	timer = 5
	choosenMove = randi_range(0,4)

func _physics_process(delta):
	if life > 0:
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
	

func _on_area_2d_body_entered(body):
	if body.name == "Martin":
		attackPlayer()# Replace with function body.


func attackPlayer():
	pass
	# var player = get_tree().get_root().get_node("res://Martin.tscn")
	#print( self.global_position)
	#print(player.global_position)
	#print((player.global_position - self.global_position).normalized())
	#var dir = (player.global_position - self.global_position).normalized()
	# move_and_collide(dir * speed)


func _on_detect_bullets_body_entered(body):
	if(body.name == "Bullets"):
		life -= 15
		spr.play("Hit")
		velocity.x = 0
		velocity.y = 0
		timer = 0
	if(body.name == "Martin"):
		life = 0
			
func explode():
	spr.play("Exploding")
	if spr.get_frame() == 7:
		initializeCoin()	
