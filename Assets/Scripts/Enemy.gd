extends CharacterBody2D
@onready var spr = $AnimatedSprite2D
@onready var lifeBar = $TextureProgressBar
@onready var sound = $AudioStreamPlayer2D
const speed = 50
var isAttacking = false
var timer
var choosenMove
var life = 150
var bullet_shoot_speed = -1
var isShooting = false
var bullet_spawner = 0.3

var path
const bulletPath = preload("res://Assets/Prefabs/enemy_bullets.tscn")
var player
func _ready():
	lifeBar.max_value = life
	timer = 5
	choosenMove = randi_range(0,4)
	player  = get_tree().get_root().get_node("Node2D").get_node("Martin")

func _physics_process(delta):
	if life > 0:
		lifeBar.value = life
		if !isAttacking:
			if timer <= 0:
				timer = randi_range(5,10)
				choosenMove = randi_range(0,4)
			else:
				timer -= 0.05
				handleBasicMovement(choosenMove)
		var collisions = move_and_collide(velocity*delta)
		if collisions != null:
			timer = randi_range(3,5)
			choosenMove = randi_range(0,4)
		if isShooting:
			if bullet_spawner <= 0:
				bullet_spawner = 0.3
				shoot(bullet_shoot_speed)
			else:
				bullet_spawner -= 0.01
	else:
		lifeBar.value = 0
		velocity.x = 0
		velocity.y = 0
		explode()
		
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
		if !isShooting:
			spr.flip_h = true
		velocity.x = -speed
		velocity.y = 0
	
	# Enemy move down
	if move == 4:
		spr.play('Run')
		if !isShooting:
			spr.flip_h = false
		velocity.x = speed
		velocity.y = 0
		
	if isShooting:
		checkPlayerPosition()
	

func checkPlayerPosition():
	if self.global_position.x > player.global_position.x :
		spr.flip_h = true
		bullet_shoot_speed = -1
	else:
		spr.flip_h = false
		bullet_shoot_speed = 1
	

func _on_area_2d_body_entered(body):
	if body:
		timer = 0
	if body.name == "Martin":
		isShooting = true
	#move_and_collide(dir * speed)


func _on_detect_bullets_body_entered(body):
	if(body.is_in_group("bullets")):
		life -= 15
		spr.play("Hit")
		velocity.x = 0
		velocity.y = 0
		if life <= 0:
			timer = 0.2
		else: 
			timer = 0
			
func shoot(bullet_shoot_pos):
	var bullet = bulletPath.instantiate()
	get_parent().add_child(bullet)
	sound.play()
	var _position = $Marker2D.global_position
	if bullet_shoot_pos < 0:
		_position.x -= 30
	else:
		_position.x += 10
	bullet.position = _position
	bullet.velocity = player.global_position - bullet.position

			
func explode():
	spr.play("Death")
	if spr.get_frame() == 0 && timer <= 0:
		initializeCoin()	
	else:
		timer -= 0.01


func _on_area_2d_body_exited(body):
	if body.name == "Martin":
		isShooting = false
