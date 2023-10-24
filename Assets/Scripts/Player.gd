extends CharacterBody2D

# Variable Params
var speed = 100
@onready var spr = $AnimatedSprite2D
@onready var lifeBar = $Camera2D/HPBar
@onready var bulletsBar = $Camera2D/bulletsBar
@onready var BulletCounter = $Camera2D/BulletCounter
@onready var HpCounter = $Camera2D/HpCounter
@onready var coinCounter = $Camera2D/StaticBody2D/coinCounter
@onready var hostCounter = $Camera2D/hostCounter
@onready var sound = $AudioStreamPlayer2D
@onready var light = $PointLight2D

var lightTimer = 0.03
var bullet_shoot_speed = 0
var health = 100
var bullets = 100
var coinCount = 0
var hosts = 0
var hasDroppedBullets = false
var hasDroppedHealth = false
# Constant params
const bulletPath = preload("res://Assets/Prefabs/bullets.tscn")

func _ready():
	spr.play("Idle")
	lifeBar.max_value = health
	bulletsBar.max_value = bullets
	HpCounter.text = str(health)

func _physics_process(_delta):
	if lightTimer <= 0:
		light.color = Color(255, 255, 255, 0.003)
	else:
		lightTimer -= 0.01
	if health > 0:
		handleInputs()
		move_and_slide()
		countCoins()
	else:
		spr.play("Death")
		
	if health >= 10:
		hasDroppedHealth = false
	if bullets >= 10:
		hasDroppedBullets = false
		
	lifeBar.value = health
	HpCounter.text = str(health)
	bulletsBar.value = bullets
	BulletCounter.text = str(bullets)

	if coinCount > 0 && bullets == 0 && !hasDroppedBullets:
		extraBullets()
		
	if coinCount > 0 && health == 2 && !hasDroppedHealth:
		extraHealth()

func countCoins():
	coinCounter.text = str(coinCount)

func handleInputs():
	if(Input.is_action_pressed("left")):
		velocity.x = -speed
		bullet_shoot_speed = -1
		spr.play("Run")
		spr.flip_h = true
	if(Input.is_action_pressed("right")):
		velocity.x = speed
		bullet_shoot_speed = 1
		spr.play("Run")
		spr.flip_h = false
	if(Input.is_action_pressed("up")):
		velocity.y = -speed
		spr.play("Run")
	if(Input.is_action_pressed("down")):
		velocity.y = speed
		spr.play("Run")
		
	if Input.is_action_just_pressed("shoot"):
		if bullets > 0:
			shoot(bullet_shoot_speed)
			
			
	if(
		Input.is_action_just_released("down") || 
		Input.is_action_just_released("up") || 
		Input.is_action_just_released("left") || 
		Input.is_action_just_released("right")
		): 
		velocity.x = 0
		velocity.y = 0
		spr.play("Idle")
		
func shoot(bullet_shoot_pos):
	bullets -= 1
	var bullet = bulletPath.instantiate()
	get_parent().add_child(bullet)
	sound.play()
	var _position = $Marker2D.global_position
	if bullet_shoot_pos < 0:
		_position.x -= 28
	bullet.position = _position
	bullet.velocity = Vector2(bullet_shoot_pos,0)
	
func extraBullets():
	hasDroppedBullets = true
	const path = preload("res://Assets/Prefabs/bullets_pack.tscn")
	var item = path.instantiate()
	get_parent().add_child(item)
	var positions = $Marker2D.global_position
	if positions.x < 0:
		positions.x -= 28
	var _position = positions
	item.position = _position
	if coinCount >= 10:
		coinCount -= 10
		item.bullets = 100
	else:
		coinCount = 0
		item.bullets += coinCount * 10
		
func extraHealth():
	hasDroppedHealth = true
	const path = preload("res://Assets/Prefabs/health_box.tscn")
	var item = path.instantiate()
	get_parent().add_child(item)
	var positions = $Marker2D.global_position
	if positions.x < 0:
		positions.x -= 28
	var _position = positions
	item.position = _position
	if coinCount >= 10:
		coinCount -= 10
		item.health = 100
	else:
		coinCount = 0
		item.health = coinCount * 10
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy_bullets"):
		health -= 5
		light.color = Color(255, 0, 0, 0.003)
		lightTimer = 0.03
		if health <= 0:
			lifeBar.value = 0
